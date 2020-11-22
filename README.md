# Android Mobile Test Engineer Knowledg

## Performance Test

### Root

A rooted phone can make performance data collecting much easier.  Just use [Magisk](https://github.com/topjohnwu/Magisk) and  follow the instructions online. ; )

### Linux Performance Tools

Android is based on Linux kernel, so we can use the Linux Performance Tools to gether your App`s performace data. This image is a quick reference from [here](http://www.brendangregg.com/linuxperf.html).

![](http://www.brendangregg.com/Perf/linux_observability_tools.png)



## Memory Usage Related

### Memory leak detection tools

We can use  [Android Studio Memory Profiler](https://developer.android.com/studio/profile/memory-profiler#profiler-memory-leak-detection) to detect memory leak. If you're more familiar with [Eclipse MAT](https://www.eclipse.org/mat/), you can [capture a heap dump](https://developer.android.com/studio/profile/memory-profiler#capture-heap-dump) |`am dumpheap`|`Debug.dumpHprofData("path")`and open it with MAT.

We can use `hprof-conv` tool provided in the `android_sdk/platform-tools/` directory to convert the HPROF file from Android format to the Java SE HPROF format. 

 To exclude non-app heap, e can also use `-z` param :

`hprof-conf [-z] infile outfile`

 `-z: exclude non-app heaps, such as Zygote`

or, use OQL :

`select * from instanceof java.lang.Object s where s.@objectAddress > [adress]`.

Some oprations will cause memory leak, such as forgetting release Bitmap, temprary byte array, file cache, Activity that contains handler and etc.

[LeakCanary](https://square.github.io/leakcanary/) is another choice for memory leak detection.

### Memory leak detection procedure

**Clean code**

Make sure the project has no useless Log, debug plugins and codes that testers write for testing. These codes and Logs may affect memory usage and cause more GC.

**Scenarios**

Suppose there`s a new feature added to your App, you should get memory usage data before|during|after running the new feature. Compare the there data set to find possible memory leak.

Suppose you would like to see the whole memory usage of your App, and detect possible memory leak. You can open your App and do nothing, just let it be there and observe the memory usage. Run the main features of your App, such as play some videos or download some files, multiple times. Switch Activities, multiple times. Switch between forground and background, multiple times. After several operations, observe the memory usage. 

It is better to get the memory usage data several times and take the average, for GC and broadcast may disturb the memory usage data.

Here are some scenarios that may cause memory leak: (a) layouts that contains images; (b) large data transfer through internet; (3) operations that cache data. 

### Memory Fragmentation

Here is a case we went through at work. Developers added some code, memory usage displayed by Android Studio Profiler almost the same with the older version. But memory usage displayed by Android system increased big. In this case, we have to check the memory use of the  App`s process using dumpsys: 

`dumpsys meminfo <package name| pid>`

<img src="/Users/yangwang/Desktop/Screen Shot 2020-11-10 at 11.31.50 PM.png" alt="Screen Shot 2020-11-10 at 11.31.50 PM" style="zoom:50%;" />

TOTAL Pss Total(1) is what you see in Android system memory use like this:

<img src="/Users/yangwang/Desktop/WechatIMG124.jpeg" alt="WechatIMG124" style="zoom: 33%;" />

Dalvik Heap Alloc(2) is what you see in Android Studio Memory.

In our case, we found App`s process memory use inceased due to Dalvik Heap Pss, and Dalvik Heap Free also increased, but why?

<img src="/Users/yangwang/Desktop/Screen Shot 2020-11-10 at 9.21.27 PM.png" alt="Screen Shot 2020-11-10 at 9.21.27 PM" style="zoom:50%;" />

Android developers best practices document give us suggestions about [how to manage App's memory](https://developer.android.com/topic/performance/memory) , also we can go though dalvik source code(dalvik/vm/alloc) to get better understanding of how memory allocated by DVM. When we get researches done, here is our guess: the problem may be **memory fragmentation**.

To check on our guess, we run the App and get the hprof file. Use Eclipse MAT, chose all objects `list_objects java.*`  and export to csv. Objects that have the same high bit address(&0xfffff000) share the same page. 

![Screen Shot 2020-11-11 at 9.31.52 PM](/Users/yangwang/Desktop/Screen Shot 2020-11-11 at 9.31.52 PM.png)

So that, we can get all pages that used less than 2KB, and use OQL to import the objects back into MAT. Then, we can have a better look at these objects, and catch those who cause memory fragmentation.

![Picture1](/Users/yangwang/Desktop/Picture1.png)

Here is the code that cause memory fragmentation:

`private Object res[] = new Object[100];`

`void foo(){`

​	`	for(int i=0; i<100; i++){`	

​		`byte[] tmp = new byte[2000];`

​		`res[i] = byte[4];`

​	`}`

`}`

### Make dex file memory efficient

We found `dex mmap` takes a big portion of the PSS Total. We got about 10,000 class in our project and the size of classes.dex is about 10MB. When the App was running, about 1500 class were loaded into memory and dex mmap size was about 4~6MB. It means lots of memory  was wasted.

This is because dex is loaded into memory by 4KB pages. Suppose we use class A, dalvik vm loads the 4KB page that contains class A into memory. If class A uses class B, then dalvik vm loads the 4KB page that contains class B. If class A and class B in the same 4KB page, dalvik vm just load one page, that is efficient.

`dexdump classes.dex`,  we found classes in dex file are arranged by alphabet. So we can use `proguard` to change class names, let classes that are frequently used arranged together.

### Other info about process memory usage

`/proc/pid/maps`

`/proc/pid/smaps`



## Network traffic statistics

There are several ways to get traffic statistics:

a.`/proc/net/xt_qtaguid/stats`  ( e.g.  `adb shell cat /proc/net/xt_qtaguid/stats  | grep (uid#)`)

b.`TrafficStats.getUidRxBytes (int uid)`  & `TrafficStats.getUidTxBytes(int uid)`  (some systems may return 0)

​	how to get a pid: `adb shell dumpsys package com.example.appname | grep userId=`

c.`/proc/uid_stat/[uid]/tcp_snd`  & ` /proc/uid_stat/[uid]/tcp_rcv` (some systsems do not have those files)

![Screen Shot 2020-11-13 at 10.22.21 PM](/Users/yangwang/Desktop/Screen Shot 2020-11-13 at 10.22.21 PM.png)

Column 6 is rx_bytes, column 8 is tx_bytes, `rx_bytes + tx_bytes = traffic statistics` 

Column 5 is cnt_set with value 0 or 1, represents the foreground and background process with the same uid.

d. tcpdump



## Battery

1.You can decompile `/system/framework-res.apk` to get  `res/xml/power_profile.xml`. Power_profile.xml contains device's hardware power values that provided by device manufacturers. 

​	Or you can use the methods in `com.android.internal.os.PowerProfile` class to get those hardware power values.

2.[Batterystats tool](https://developer.android.com/topic/performance/power/setup-battery-historian) shows detail usage of energy, befor data gathering, it's better running these two commands:

​	`dumpsys batterystats --enable full-wake-history`

​	`dumpsys batterystats --reset`

3. When device is in sleep mode, the main energy consumption comes from device being wakeup. Use `dumpsys alarm` and Wakelock Detector helps to analyze who wakeup the device.

   

## UI Performance

Use `adb shell dumpsys gfxinfo <package name>` to [test UI performance](https://developer.android.com/training/testing/performance).

Or use [Choreographer.FrameCallback](https://developer.android.com/reference/android/view/Choreographer.FrameCallback) interface to detect if the system updates 60 frames per second. [Here is the sample code](https://github.com/Tencent/GT/blob/master/android/GT-%E6%B5%81%E7%95%85%E6%80%A7%E6%A3%80%E6%B5%8B%E5%8E%9F%E7%90%86%E5%8F%8A%E8%A7%84%E5%88%99.md)

Here's some advices for [Reduce GPU Overdraw](https://developer.android.com/topic/performance/rendering/overdraw)

Use [Lint](https://developer.android.com/studio/write/lint) to detect code that may affect UI performance



## Identify app startup bottlenecks

1. Record a vedio and count

2. Systrace activity manager

   ![Screen Shot 2020-11-18 at 2.58.58 PM](/Users/yangwang/Desktop/Screen Shot 2020-11-18 at 2.58.58 PM.png)

bindApplication is time to load Application

activityStart = Application + SplashAcivity + MainActivity

3. Check Main thread IO/ Network data transfer / 	大量运算

   将耗时操作移出ui线程

   IO in main thread can affect startup time, IOmonitor



## Make your apk smaller

[Reduce your app size](https://developer.android.com/topic/performance/reduce-apk-size) gives us several advices. And here are something we can do more:

1. Use UCDetector to find unnecessary code.

2. Use Simian tool to find duplication in code.
3. Find unused image in older version. Pay attention to `android:visibility="gone"` in xml file and `view.setVisibility(View.GONE)` in java code.