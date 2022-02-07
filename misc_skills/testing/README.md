## Testing a Real World Object
**_Question: How would you test a paperclip?_**
**_Step 1: Who will use it? And why?_**
You need to discuss with your interviewer who is using the product and for what purpose. The answer may not be what you think. The answer could be"by teachers, to hold papers together;' or it could be"by artists, to bend into the shape of animal:' Or, it could be both. The answer to this question will shape how you handle the remaining questions.
**_Step 2: What are the use cases?_**
It will be useful for you to make a list of the use cases. In this case, the use case might be simply fastening paper together in a non-damaging (to the paper) way.
For other questions, there might be multiple use cases. It might be, for example, that the product needs to be able to send and receive content, or write and erase, and so on.
**_Step 3: What are the bounds of use?_**
The bounds of use might mean holding up to thirty sheets of paper in a single usage without permanent damage (e.g., bending), and thirty to fifty sheets with minimal permanent bending.
The bounds also extend to environmental factors as well. For example, should the paperclip work during very warm temperatures (90 - 110 degrees Fahrenheit)? What about extreme cold?
**_Step 4: What are the stress/ failure conditions?_**
No product is fail-proof, so analyzing failure conditions needs to be part of your testing. A good discussion to have with your interviewer is about when it's acceptable (or even necessary) for the product to fail, and what failure should mean.
For example, if you were testing a laundry machine, you might decide that the machine should be able to handle at least 30 shirts or pants. Loading 30 - 45 pieces of clothing may result in minor failure, such as the clothing being inadequately cleaned. At more than 45 pieces of clothing, extreme failure might be accept­ able. However, extreme failure in this case should probably mean the machine never turning on the water. It should certainly not mean a flood or a fire.
**_Step 5: How would you perform the testing?_**
In some cases, it might also be relevant to discuss the details of performing the testing. For example, if you need to make sure a chair can withstand normal usage for five years, you probably can't actually place it in a home and wait five years. Instead, you'd need to define what"normal" usage is (How many "sits" per year on the seat? What about the armrest?). Then, in addition to doing some manual testing, you would likely want a machine to automate some of the usage.

## Testing a Function
**_Step 1: Define the test cases_**
In general, you should think about the following types of test cases:
**The normal case:** Does it generate the correct output for typical inputs? Remember to think about poten­tial issues here. For example, because sorting often requires some sort of partitioning, it's reasonable to think that the algorithm might fail on arrays with an odd number of elements, since they can't be evenly partitioned. Your test case should list both examples.
**The extremes:** What happens when you pass in an empty array? Or a very small (one element) array? What if you pass in a very large one?
**Nulls and "illegal" input:** It is worthwhile to think about how the code should behave when given illegal input. For example, if you're testing a function to generate the nth Fibonacci number, your test cases should probably include the situation where n is negative.
**Strange input:** A fourth kind of input sometimes comes up: strange input. What happens when you pass in an already sorted array? Or an array that's sorted in reverse order?
Generating these tests does require knowledge of the function you are writing. If you are unclear as to the constraints, you will need to ask your interviewer about this first.
**_Step 2: Define the expected result_**
Often, the expected result is obvious: the right output. However, in some cases, you might want to validate additional aspects. For instance, if the sort method returns a new sorted copy of the array, you should probably validate that the original array has not been touched.
**_Step 3: Write test code_**
Once you have the test cases and results defined, writing the code to implement the test cases should be fairly straightforward.Your code might look something like:
```
void testAddThreeSorted() {
Mylist list = new Mylist();
list.addThreeSorted(3, 1, 2); // Adds 3 items in sorted order
a s s ertEquals(list.getElement(0), 1);
assertEquals(list.getElement(l), 2);
assertEquals(list.getElement(2), 3);
}
```

## Questions:
**1. Chess Test:** We have the following method used in a chess game: boolean canMoveTo(int x, int y).This method is part of the Piece class and returns whether or not the piece can move to position(x, y).Explain how you would test this method.
**Solution:**
In this problem, there are two primary types of testing: extreme case validation (ensuring that the program doesn't crash on bad input), and general case testing. We'll start with the first type.
Testing Type #1: Extreme Case Validation
We need to ensure that the program handles bad or unusual input gracefully. This means checking the following conditions:
Test with negative numbers for x and y Test with x larger than the width
Test with y larger than the height
Test with a completely full board
Test with an empty or nearly empty board
Test with far more white pieces than black
Test with far more black pieces than white
For the error cases above, we should ask our interviewer whether we want to return false or throw an excep­tion, and we should test accordingly.
```
	@Test
	public void whenExceptionThrown_thenAssertionSucceeds() {
		Exception exception = assertThrows(NumberFormatException.class, () -> {
			Integer.parseInt("1a");
		});

		String expectedMessage = "For input string";
		String actualMessage = exception.getMessage();

		assertTrue(actualMessage.contains(expectedMessage));
	}
```
Testing Type #2: General Testing:
General testing is much more expansive. Ideally, we would test every possible board, but there are far too many boards. We can, however, perform a reasonable coverage of different boards.
There are 6 pieces in chess, so we can test each piece against every other piece, in every possible direction. This would look something like the below code:
```
foreach piece a:
for each other type of piece b (6 types + empty space)
foreach direction d
Create a board with piece a.
Place piece b in direction d.
Try to move - check return value.
```
The key to this problem is recognizing that we can't test every possible scenario, even if we would like to. So, instead, we must focus on the essential areas.

**2. Test a Pen:** How would you test a pen?
**Solution:**
This problem is largely about understanding the constraints and approaching the problem in a structured manner.
To understand the constraints, you should ask a lot of questions to understand the "who, what, where, when, how and why" of a problem (or as many of those as apply to the problem). Remember that a good tester understands exactly what he is testing before starting the work.
To illustrate the technique in this problem, let us guide you through a mock conversation.
Interviewer: How would you test a pen?
Candidate: Let me find out a bit about the pen. Who is going to use the pen?
• Interviewer: Probably children.
• Candidate: Okay, that's interesting. What will they be doing with it? Will they be writing, drawing, or doing something else with it?
Interviewer: Drawing.
Candidate: Okay, great. On what? Paper?Clothing?Walls?
• Interviewer: On clothing.
• Candidate: Great. What kind of tip does the pen have? Felt? Ballpoint? Is it intended to wash off, or is it intended to be permanent?
Interviewer: It's intended to wash off. Many questions later, you may get to this:
Candidate: Okay, so as I understand it, we have a pen that is being targeted at 5 to 10-year-olds. The pen has a felt tip and comes in red, green, blue and black. It's intended to wash off when clothing is washed. Is that correct?
The candidate now has a problem that is significantly different from what it initially seemed to be. This is not uncommon. In fact, many interviewers intentionally give a problem that seems clear (everyone knows what a pen is!), only to let you discover that it's quite a different problem from what it seemed. Their belief is that users do the same thing, though users do so accidentally.
Now that you understand what you're testing, it's time to come up with a plan of attack. The key here is structure.
Consider what the different components of the object or problem, and go from there. In this case, the components might be:
Fact check: Verify that the pen is felt tip and that the ink is one of the allowed colors. Intended use: Drawing. Does the pen write properly on clothing?
Intended use: Washing. Does it wash off of clothing (even if it's been there for an extended period of time)? Does it wash off in hot warm and cold water?
Safety: Is the pen safe (non-toxic) for children?
Unintended uses: How else might children use the pen?They might write on other surfaces, so you need
to check whether the behavior there is correct. They might also stomp on the pen, throw it, and so on. 
You'll need to make sure that the pen holds up under these conditions.
Remember that in any testing question, you need to test both the intended and unintended scenarios. People don't always use the product the way you want them to.

**3. Test an ATM:** How would you test an ATM in a distributed banking system?
**Solution:**
The first thing to do on this question is to clarify assumptions. Ask the following questions:
• Who is going to use the ATM? Answers might be "anyone;' or it might be "blind people;' or any number of other answers.
What are they going to use it for? Answers might be "withdrawing money;' "transferring money;' "checking their balance;' or many other answers.
• What tools do we have to test? Do we have access to the code, or just to the ATM?
Remember: a good tester makes sure she knows what she's testing!
Once we understand what the system looks like, we'll want to break down the problem into different test­ able components. These components include:
• Logging in
• Withdrawing money Depositing money
• Checking balance
• Transferring money
We would probably want to use a mix of manual and automated testing.
Manual testing would involve going through the steps above, making sure to check for all the error cases (low balance, new account, nonexistent account, and so on).
Automated testing is a bit more complex. We'll want to automate all the standard scenarios, as shown above, and we also want to look for some very specific issues, such as race conditions. Ideally, we would be able to set up a closed system with fake accounts and ensure that, even if someone withdraws and deposits money rapidly from different locations, he never gets money or loses money that he shouldn't.
Above all, we need to prioritize security and reliability. People's accounts must always be protected, and we must make sure that money is always properly accounted for. No one wants to unexpectedly lose money! A good tester understands the system priorities.

## Automation Test Best Practice
### Properties and Parameters
Use `config.properties` file, TestNG `<parameter>`, `json` file and `string.xml` for project parameters and variables.
### Driver wait
```
	public void waitForVisibility(MobileElement e){
		WebDriverWait wait = new WebDriverWait(driver, TestUtils.WAIT);
		wait.until(ExpectedConditions.visibilityOf(e));
	}
```
### Fluent Page Object Model Design
### TestNG Listener

## Automation Test How to
### How to check device id of iPhone simulator?
```
1. instruments -s devices
2. xcrun simctl list
3. From Xcode: Window -> Devices and Simulators -> Simulators. The Identifier value is the UDID.
```

### How to get udid
```
adb devices
```

### How to get appActivity and appPackage
```
adb shell "dumpsys activity activities | grep mResumedActivity"
```

### Android Locator Strategies
|Locator Strategy|Description|Example|Code|
|-----|-----|----------|----------|
|Accessibility ID|content-desc attribute|<unique_element_name>|driver.findElementByAccessibilityId("<unique_element_name>");|
|ID|resource-id attribute|<app_package>/<resource-id>|driver.findElementById("<resource-id>");|
|Class Name|Uiautomator2 class name|android.widget.TextView|driver.findElementByClassName("android.widget.TextView");|
|XPath|XML path expression|//<UiAutomator2 Class Name>[@<attribute name>="attribute value"]/<axes>::<expression>|driver.findElementByXPath();|
|Image|matches with base64 encode image file|<base64_encode_string>|driver.findElementByImage("<base64_encode_string>");|
|UiAutomator2(UiSelector)|UI Automator API, use UiSelector class|"new UiSelector().text(\"Animation\")"|((FindsByAndroidUIAutomator)driver).findElementByAndroidUIAutomator("new UiSelector().text(\"Animation\")");|
