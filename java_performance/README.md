# Notes of *Java Performance - The Definitive Guid*

## Four Principles of Getting Results form Performance Testing
### 1.Test a Real Application
#### Microbenchmarks
<pre><code>
public class FibonacciTest {
    // volatile keyword is used to make sure compiler won`t discard unused variables
    private volatile double l; 
    private int nLoops; 
    private int[] input;

    public static void main(String[] args) {
        FibonacciTest ft = new FibonacciTest(Integer.parseInt(args[0]));
        // For microbenchmarks, a warm-up period is required; 
        // otherwise, the microbenchmark is measuring the performance of compilation 
        // rather than the code it is attempting to measure.
        ft.doTest(true);
        ft.doTest(false);
    }

    // extraneous operations should not include in microbenchmark
    // If we always run fibImply(50) A very smart compiler can figure that out 
    // and execute the loop only once or at least discard some of the iterations of the loop 
    // since those operations are redundant.
    private FibonacciTest(int n) { 
        nLoops = n;
        input = new int[nLoops];
        Random r = new Random(); 
        for(inti = 0; i < nLoops ; i++){
            input[i] = r.nextInt(100);
        }
    }

    private void doTest(boolean isWarmup) { 
        long then = System.currentTimeMillis(); 
        for(inti = 0 ; i < nLoops ; i++){
            l = fibImpl1(input[i]);
        }
        if (!isWarmup) {
            long now = System.currentTimeMillis(); 
            System.out.println((now - then));
        } 
    }

    private double fibImpl1(int n) {
        if (n < 0) throw new IllegalArgumentException("Must be > 0");
        if (n == 0) return 0d;
        if (n == 1) return 1d;
        double d = fibImpl1(n - 2) + fibImpl(n - 1);
        if (Double.isInfinite(d)) throw new ArithmeticException("Overflow"); 
        return d;
    }
}
</code></pre>
### 2.Understand Throughput, Batching, and Response Time
### 3.Understand Variability
### 4.Test Early, Test Often

## Java Performance Toolbox
### Operating System tools
vmstat 1 <br>
iostat -xm 5 <br>
nicstat 5
### Java Monitoring Tools
jcmd process_id VM.uptime<br>
jcmd process_id VM.system_properties<br>
jinfo -sysprops process_id<br>
jcmd process_id VM.version<br>
## JIT (Just-in-Time) Compiler Optimizations
### Registers and Main Memory
One of the most important optimizations a compiler can make involves when to use values from main memory and when to store values in a register. Consider this code:
<pre><code>public class RegisterTest {
    private int sum;
    public void calculateSum(int n) {
        for(inti=0 ; i < n ; i++){
            sum += i;
        }
    }
}</code></pre>
<p>At some point in time, the sum instance variable must reside in main memory, but retrieving a value from main memory is an expensive operation that takes multiple cycles to complete. If the value of sum were to be retrieved from (and stored back to) 
main memory on every iteration of this loop, performance would be dismal. Instead, the compiler will load a register with the initial value of sum, perform the loop using that value in the register, and then (at an indeterminate point in time) store 
the final result from the register back to main memory.</p>
<p>This kind of optimization is very effective, but it means that the semantics of thread synchronization are crucial to the behavior of the application. One thread cannot see the value of a variable stored in the register used by another 
thread; synchronization makes it possible to know exactly when the register is stored to main memory and available to other threads.</p>
<p>Register usage is a general optimization of the compiler, and when escape analysis is enabled, register use is quite aggressive.</p>

## Heap Memory Best Practices
### Heap Analysis
1. Heap Histograms
<pre>jcmd process_id GC.class_histogram
jmap -histo process_id
jmap -histo:live process_id</pre>
(If you’re unfamiliar with the syntax here, it comes from the way the Java Native Interface (JNI) identifies object types; see the JNI reference documentation for more details.)
2. Heap Dumps
<pre>jcmd process_id GC.heap_dump /path/to/heap_dump.hprof
jmap -dump:live,file=/path/to/heap_dump.hprof process_id</pre>
### Using Less Memory
1. Reducing Object Size
2. Lazy Initialization(To be clarified)

# Misc Java Topics
## Stack Memory and Heap Space in Java
Whenever we declare new variables and objects, call a new method, declare a String, or perform similar operations, JVM designates memory to these operations from either Stack Memory or Heap Space.
### 1.Stack Memory in Java
Stack Memory in Java is used for static memory allocation and the execution of a thread. It contains primitive values that are specific to a method and references to objects referred from the method that are in a heap.<br>
Access to this memory is in Last-In-First-Out (LIFO) order. Whenever we call a new method, a new block is created on top of the stack which contains values specific to that method, like primitive variables and references to objects.<br>
When the method finishes execution, its corresponding stack frame is flushed, the flow goes back to the calling method, and space becomes available for the next method.

_**Key Features of Stack Memory**_
Some other features of stack memory include:
<li>It grows and shrinks as new methods are called and returned, respectively.</li>
<li>Variables inside the stack exist only as long as the method that created them is running.</li>
<li>It's automatically allocated and deallocated when the method finishes execution.</li>
<li>If this memory is full, Java throws java.lang.StackOverFlowError.</li>
<li>Access to this memory is fast when compared to heap memory.</li>
<li>This memory is threadsafe, as each thread operates in its own stack.</li>

### 2.Heap Space in Java
Heap space is used for the dynamic memory allocation of Java objects and JRE classes at runtime. New objects are always created in heap space, and the references to these objects are stored in stack memory.
These objects have global access and we can access them from anywhere in the application.

_**Key Features of Java Heap Memory**_
Some other features of heap space include:
<li>It's accessed via complex memory management techniques that include the Young Generation, Old or Tenured Generation, and Permanent Generation.</li>
<li>If heap space is full, Java throws java.lang.OutOfMemoryError.</li>
<li>Access to this memory is comparatively slower than stack memory</li>
<li>This memory, in contrast to stack, isn't automatically deallocated. It needs Garbage Collector to free up unused objects so as to keep the efficiency of the memory usage.</li>
<li>Unlike stack, a heap isn't threadsafe and needs to be guarded by properly synchronizing the code.</li>

### Example
<pre><code>
class Person {
    int id;
    String name;

    public Person(int id, String name) {
        this.id = id;
        this.name = name;
    }
}

public class PersonBuilder {
    private static Person buildPerson(int id, String name) {
        return new Person(id, name);
    }

    public static void main(String[] args) {
        int id = 23;
        String name = "John";
        Person person = null;
        person = buildPerson(id, name);
    }
}
</code></pre>

![Example](https://github.com/yangwang000/PerformanceTest/blob/main/java_performance/pics/java-heap-stack-diagram.png)

[1]https://www.baeldung.com/java-stack-heap <br>
[2]https://www.betsol.com/blog/java-memory-management-for-java-virtual-machine-jvm/

## Class loading, Transaction management etc.
