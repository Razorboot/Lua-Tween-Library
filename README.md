# Lua-Tween-Library
<br/>

## Notice:
Keep in mind that this post is intended for those with at least basic scripting knowledge, though it is also intended to be understood by beginners! 
If you have any questions or need help, feel free to dm me on Razorboot#5718.
<br/>

## What Is This?
* This is similar implementation to Roblox's Tween Service with the addition of more aspects of control, and is also compatible with older versions of the Roblox Client. The earliest tested version is as far back as 2014 Studio.
* I plan to have a general implementation intended for general Lua usage and not Roblox-specific.
* In its simplest form, Tweening is an animation, or the process of moving one number from one value to another in different “styles”. A style is how fast this number moves between these two values.
* This can get more complicated as you introduce different types of values, such as Positions, Rotations, CFrames (Model matrices), and more.
<br/>

## Demos:
* The source code for these demos are at the bottom of this page:
* ![9d8a94944bde4136e7b38b5c51592577](https://user-images.githubusercontent.com/103084464/206599262-f019647f-2de0-4213-82b6-ee932a711e63.gif)
* ![easeInOutBounce_Dur3_Loop2](https://user-images.githubusercontent.com/103084464/206599271-e4dc5de9-09f8-4958-8ee6-697e34799e4f.gif)
<br/>

## How Do I use it?
# Step 1.) Download the module:
* The Roblox variant of the module is titled as ``Tween_Roblox.lua`` in the repo. You can either copy the code into a ``ModuleScript`` located in ``game.ReplicatedStorage``, or download the ``Tween_Place.rbxl`` file and execute it.
<br/>

# Step 2.) Set up the module:
* To use the Roblox variant of the module, create a new ``Script`` or ``LocalScript`` and include the module:
```lua
--# Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--# Include
local Tween = require(:WaitForChild("Tween"))
```
<br/>

# Step 3.) Creating a Tween:
* To create a new ``Tween`` instance using the Roblox variant of the module, type:
```lua
local newTween = Tween:new()
```
<br/>

# Step 4.) Setting the properties of your Tween instance:
* There’s tons of properties that your Tween can have, all of them are explained in the Tween
module!
```lua
duration = 1, 					-- The time in seconds that the Tween will last.
increment = 0.036, 				-- The rate of change for the Tweenable property. (Might need to change this depending on your FPS)
easingFunction = "easeInSine",	-- The direction and style of the Tween.
delay = 0,						-- How many seconds to wait before playing the animation.
isReversed = false,				-- Whether the Tween plays in reverse or not.
loopCount = 0,					-- How many times the Tween is repeated after playing once.
maxIncrement = nil,				-- (If nil, this property is disabled!) The time of the Tween goes from 0 - 1, this will end the Tween if the current time of the Tween is this value.
snapAtEnd = true,				-- Whether the Tweenable property will snap to it's goal value once the maxIncrement is met.
```
* Here is an example of a few properties you can set for your Tween:
* Hint - Check https://easings.net/ to see the different easing functions you can use.
```lua
newTween.easingFunction = "easeInOutElastic"
newTween.duration = 3
newTween.isReversed = false
newTween.loopCount = 0
```
<br/>

# Step 5.) Tweening an Object:
* Practically any property of an Instance is Tweenable. Though there are a few parameters I’ll have to cover before you can start Tweening!
<br/>

# Step 5.1) tweenObjects:
* When Tweening, you’ll need two tables to represent the Instances you want to Tween.
* The first Table is called ``tweenObjects``, which includes the *Instance* you want to Tween, and the ``Property`` of that Instance that will be modified.
```lua
local tweenObjects = {
  -- This will tween the CFrame of a Part.
  {instance = workspace.Part,
  property = "CFrame"},
}
```

* You can also animate multiple properties at the same time by simply adding another table to the ``tweenObjects`` table.
* Here’s an example of Tweening both the ``CFrame`` of a *Part*, and the ``Transparency`` of another *Part*.
```lua
local tweenObjects = {
  -- This will tween the CFrame of a Part.
  {instance = workspace.Part,
  property = "CFrame"},
  
  -- This will tween the Transparency of another Part in workspace named "BasePlate".
  {instance = workspace.BasePlate,
  property = "Transparency"}
}
```

# Step 5.2) tweenGoals:
* The second Table is called ``tweenGoals``, which includes the beginning and end parameters of your Tween. In this case, it’s the starting and end ``CFrame``.
* Hint - if you set start to ``nil``, it will just default to the initial ``CFrame`` of the *Part*!
```lua
local tweenGoals = {
  -- The Part's CFrame will start from it's current value, to the position (-6, 0.5, -14)
  {start = nil,
  goal = CFrame.new(-26, 0.5, -14)},
}
```

* If you have multiple properties in ``tweenObjects``, keep in mind you’ll have to add more tables to the ``tweenGoals`` table.
* Here’s a continuation of the multi-properties example I provided for ``tweenObjects``:
```lua
local tweenGoals = {
  -- The Part's CFrame will start from it's current value, to the position (-6, 0.5, -14)
  {start = nil,
  goal = CFrame.new(-26, 0.5, -14)},

  -- The Part named "BasePlate" will  have it's Transparency start from it's current value, 0, to the 1.
  {start = nil,
  goal = 1.0},
}
```
<br/>

# Step 5.3) Playing your Tween:
* Finally, you can play the Tween you created using:
```lua
newTween:play(tweenObjects, tweenGoals, "Server")
```
* The third parameter is where the Tween was fired from. If you’re using a regular ``Script``, then you would type ``“Server”``, if you’re using a ``LocalScript``, type ``“Client”``. This is simply used to determine the update execution time that will be used when tweening the object.
* Hint - If you want code ahead of the Tween to still process despite the Tween still running, use:
```lua
spawn(function() -- spawn might be written as Spawn depending on the version of studio you're using:
  newTween:play(tweenObjects, tweenGoals, "Server")
 end)
 -- The code below will run even if the Tween is still playing now.
```
* Hint - You can also check if a Tween is playing using ``Tween.isPlaying``. More properties can be found inside of the module itself.

# Step 6.) Ending your Tween:
* You can easily stop your Tween any time using:
```lua
newTween:stop(false)
```

* You can also use the parameters ``canSnap`` and ``resetTime`` to end your Tween.
* ``canSnap``, when set to ``true`` means that the Tween will automatically snap to the ending value when stopped.
* ``resetTime`` will wait a specified amount of seconds before ending the Tween.
```lua
newTween:stop(true, 1) -- Wait one second, then snap the property to the end point.
```

* Hint - If you have ``isReversed`` set to ``true`` in your Tween and you have a number higher than 0 for ``loopCount``, you may need to reset it's value after the ``Tween:stop()`` function is exececuted to ensure that if the Tween is played again, it reverses properly.
```lua
newTween:stop(false)
newTween.isReversed = false -- Since the tween is repeated, It reversed after the second loop, so it must be set back at the end to not start from the opposite position.
```
<br/>

# Out Tween in action:
* Here is the completed Tween!
* ![easeInOutBounce_Dur3_Loop2](https://user-images.githubusercontent.com/103084464/206597757-b2911fbf-202e-411e-9b67-200082bfdc0c.gif)
* And here is the entire Script for this Tween:
```lua
--# Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")


--# Include
local Tween = require(ReplicatedStorage:WaitForChild("Tween"))


--# Execution
local newTween = Tween:new()
newTween.easingFunction = "easeOutBounce"
newTween.duration = 3
newTween.isReversed = false
newTween.loopCount = 1

local tweenObjects = {
	{instance = workspace.Part,
	property = "CFrame"},
	
	{instance = workspace.BasePlate,
	property = "Transparency"},
}
local tweenGoals = {
	{start = nil,
	 goal = CFrame.new(-26, 0.5, -14)},
	
	{start = nil,
	 goal = 1.0},
}
newTween:play(tweenObjects, tweenGoals, "Server")
newTween.isReversed = false -- Since the tween is repeated once, It reverses after the second loop, so I just set reversed to false at the end.
```
<br/>

# Other Examples:
** A Tween that loops one time and manipulates multiple properties.**
* ![9d8a94944bde4136e7b38b5c51592577](https://user-images.githubusercontent.com/103084464/206599060-435d0e10-4e19-40a4-8f89-2058dca59aca.gif)
```lua
--# Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")


--# Include
local Tween = require(ReplicatedStorage:WaitForChild("Tween"))


--# Execution
local newTween = Tween:new()
newTween.easingFunction = "easeOutBounce"
newTween.duration = 2
newTween.isReversed = false
newTween.loopCount = 999999

local tweenObjects = {
	{instance = script.Parent.ScreenGui.Frame,
	property = "Position"},
	
	{instance = script.Parent.ScreenGui.Frame,
	property = "Rotation"},
}
local tweenGoals = {
	{start = nil,
	 goal = UDim2.new(1, -100, 0.5, -50)},
	
	{start = nil,
	 goal = 90},
}
newTween:play(tweenObjects, tweenGoals, "Server")
newTween.isReversed = false -- Since the tween is repeated, It reversed after the second loop, so I just set it back at the end.
```



