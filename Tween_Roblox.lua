--[[
	Created By: Razorboot
	Last Modified: 11/28/22
	Description: 
		This is a custom Tweening library made from scratch with the aid of (https://easings.net/)
		With this library, you can animate any numeric property of any instance such as Vector3, Vector2, and CFrames!
--]]


--# Services
local RunService = game:GetService("RunService")


--# Class Creation
local Tween = {}
Tween.__index = Tween

function Tween:new()
    local newTween = {
		duration = 1, 					-- The time in seconds that the Tween will last.
		increment = 0.036, 				-- The rate of change for the Tweenable property. (Might need to change this depending on your FPS)
		easingFunction = "easeInSine",	-- The direction and style of the Tween.
		delay = 0,						-- How many seconds to wait before playing the animation.
		isReversed = false,				-- Whether the Tween plays in reverse or not.
		loopCount = 0,					-- How many times the Tween is repeated after playing once.
		maxIncrement = nil,				-- (If nil, this property is disabled!) The time of the Tween goes from 0 - 1, this will end the Tween if the current time of the Tween is this value.
		snapAtEnd = true,				-- Whether the Tweenable property will snap to it's goal value once the maxIncrement is met.
		
		-- Do not edit the properties below, they're changed depending on the state of the Tween:
		
		isPlaying = false, 				-- Whether the Tween is active or not.
		objects = nil,					-- The information for the instances and properties that will be Tweened.
		goalObjects = nil				-- The information for the Start and End Tween properties.
    }
	
    setmetatable(newTween, Tween)
    return newTween
end


--# Optimized References
local Cos, Sin, Pow, Pi, Atan, Atan2, Asin, Rad = math.cos, math.sin, math.pow, math.pi, math.atan, math.atan2, math.asin, math.rad
local UDIM2, Vec3, Vec2, CF, CFA = UDim2.new, Vector3.new, Vector2.new, CFrame.new, CFrame.Angles


--# Tween/easing functions (DO NOT mess with these unless you know what you're doing)
local easingFunctions = {}

-- Linear
function easingFunctions.easeLinear(x)
	return x
end

-- Sine
function easingFunctions.easeInSine(x)
	return 1 - Cos((x * Pi) / 2)
end

function easingFunctions.easeOutSine(x)
	return Sin((x * Pi) / 2)
end

function easingFunctions.easeInOutSine(x)
	return -(Cos(Pi * x) - 1) / 2
end

-- Cubic
function easingFunctions.easeInCubic(x)
	return x * x * x
end

function easingFunctions.easeOutCubic(x)
	return 1 - Pow(1 - x, 3)
end

function easingFunctions.easeInOutCubic(x)
	if x < 0.5 then
		return 4 * x * x * x 
	else
		return 1 - Pow(-2 * x + 2, 3) / 2
	end
end

-- Quint
function easingFunctions.easeInQuint(x)
	return x * x * x * x * x
end

function easingFunctions.easeOutQuint(x)
	return 1 - Pow(1 - x, 5)
end

function easingFunctions.easeInOutQuint(x)
	if x < 0.5 then
		return 16 * x * x * x * x * x 
	else
		return 1 - Pow(-2 * x + 2, 5) / 2
	end
end

-- Circ
function easingFunctions.easeInCirc(x)
	return 1 - math.sqrt(1 - Pow(x, 2))
end

function easingFunctions.easeOutCirc(x)
	return math.sqrt(1 - Pow(x - 1, 2))
end

function easingFunctions.easeInOutCirc(x)
	if x < 0.5 then
		return (1 - math.sqrt(1 - Pow(2 * x, 2))) / 2
	else
		return (math.sqrt(1 - Pow(-2 * x + 2, 2)) + 1) / 2
	end
end

-- Elastic
function easingFunctions.easeInElastic(x)
	local c4 = (2 * Pi) / 3

	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	else
		return -Pow(2, 10 * x - 10) * Sin((x * 10 - 10.75) * c4)
	end
end

function easingFunctions.easeOutElastic(x)
	local c4 = (2 * Pi) / 3
	
	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	else
		return Pow(2, -10 * x) * Sin((x * 10 - 0.75) * c4) + 1
	end
end

function easingFunctions.easeInOutElastic(x)
	local c5 = (2 * Pi) / 4.5;
	
	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	elseif x < 0.5 then
		return -(Pow(2, 20 * x - 10) * Sin((20 * x - 11.125) * c5)) / 2
	else
		return (Pow(2, -20 * x + 10) * Sin((20 * x - 11.125) * c5)) / 2 + 1
	end
end

-- Quad
function easingFunctions.easeInQuad(x)
	return x * x
end

function easingFunctions.easeOutQuad(x)
	return 1 - (1 - x) * (1 - x)
end

function easingFunctions.easeInOutQuad(x)
	if x < 0.5 then
		return 2 * x * x
	else
		return 1 - Pow(-2 * x + 2, 2) / 2
	end
end

-- Quart
function easingFunctions.easeInQuart(x)
	return x * x * x * x
end

function easingFunctions.easeOutQuart(x)
	return 1 - Pow(1 - x, 4)
end

function easingFunctions.easeInOutQuart(x)
	if x < 0.5 then
		return 8 * x * x * x * x
	else
		return 1 - Pow(-2 * x + 2, 4) / 2
	end
end

-- Expo
function easingFunctions.easeInExpo(x)
	if x == 0 then
		return 0
	else
		return Pow(2, 10 * x - 10)
	end
end

function easingFunctions.easeOutExpo(x)
	if x == 1 then
		return 1
	else
		return 1 - Pow(2, -10 * x)
	end
end

function easingFunctions.easeInOutExpo(x)
	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	else
		if x < 0.5 then
			return Pow(2, 20 * x - 10) / 2
		else
			return (2 - Pow(2, -20 * x + 10)) / 2
		end
	end
end

-- Back
function easingFunctions.easeInBack(x)
	local c1 = 1.70158
	local c3 = c1 + 1
	
	return c3 * x * x * x - c1 * x * x;
end

function easingFunctions.easeOutBack(x)
	local c1 = 1.70158
	local c3 = c1 + 1
	
	return 1 + c3 * Pow(x - 1, 3) + c1 * Pow(x - 1, 2);
end

function easingFunctions.easeInOutBack(x)
	local c1 = 1.70158
	local c2 = c1 * 1.525

	if x < 0.5 then
		return (Pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2
	else
		return (Pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2
	end
end

-- Bounce
function easingFunctions.easeOutBounce(x)
	local n1 = 7.5625
	local d1 = 2.75
	
	if (x < 1 / d1) then
	    return n1 * x * x
	elseif (x < 2 / d1) then
		x = x - (1.5 / d1)
	    return n1 * x * x + 0.75
	elseif (x < 2.5 / d1) then
		x = x - (2.25 / d1)
	    return n1 * x * x + 0.9375
	else
		x = x - (2.625 / d1)
	    return n1 * x * x + 0.984375
	end
end

function easingFunctions.easeInBounce(x)
	return 1 - easingFunctions.easeOutBounce(1 - x)
end

function easingFunctions.easeInOutBounce(x)
	if x < 0.5 then
		return (1 - easingFunctions.easeOutBounce(1 - 2 * x)) / 2
	else
		return (1 + easingFunctions.easeOutBounce(2 * x - 1)) / 2
	end
end


--# Local Methods
local function hasProperty(object, prop)
	local t = object[prop]
end

local function typeof(object)
	if type(object) == "string" then
		return "string"
	elseif type(object) == "number" then
		return "number"
	elseif type(object) == "userdata" then
		-- Check if the object is a UDim2
		local success = pcall(function() hasProperty(object, "X") end)
		if success == true then 
			success = pcall(function() hasProperty(object.X, "Offset") end)
			if success then return "UDim2" end
		end
		
		-- Check if the object is a CFrame
		local success = pcall(function() hasProperty(object, "p") end)
		if success == true then return "CFrame" end
		
		-- Check if the object is a Vector3
		success = pcall(function() hasProperty(object, "z") end)
		if success == true then return "Vector3" end
		
		-- Check if the object is a Vector2
		success = pcall(function() hasProperty(object, "y") end)
		if success == true then return "Vector2" end
	end
end

local function lerpNum(a, b, t)
	return a + (b - a) * t
end

local function LerpVec2(a, b, dt) -- Move a Vector2 from one point to another by a desired amount.
	local ax, ay = lerpNum(a.x, b.x, dt), lerpNum(a.y, b.y, dt)
	return Vec2(ax, ay)
end

local function LerpVec3(a, b, dt) -- Move a Vector3 from one point to another by a desired amount.
	local ax, ay, az = lerpNum(a.x, b.x, dt), lerpNum(a.y, b.y, dt), lerpNum(a.z, b.z, dt)
	return Vec3(ax, ay, az)
end

local function LerpCF(CFA, CFB, dt) -- Move a CFrame from one point to another by a desired amount.
	local Ax, Ay, Az, Am11, Am12, Am13, Am21, Am22, Am23, Am31, Am32, Am33 = CFA:components()
	local Bx, By, Bz, Bm11, Bm12, Bm13, Bm21, Bm22, Bm23, Bm31, Bm32, Bm33 = CFB:components()
	
	Ax, Ay, Az = lerpNum(Ax, Bx, dt), lerpNum(Ay, By, dt), lerpNum(Az, Bz, dt)
	Am11, Am12, Am13 = lerpNum(Am11, Bm11, dt), lerpNum(Am12, Bm12, dt), lerpNum(Am13, Bm13, dt)
	Am21, Am22, Am23 = lerpNum(Am21, Bm21, dt), lerpNum(Am22, Bm22, dt), lerpNum(Am23, Bm23, dt)
	Am31, Am32, Am33 = lerpNum(Am31, Bm31, dt), lerpNum(Am32, Bm32, dt), lerpNum(Am33, Bm33, dt)
	
	return CF(Ax, Ay, Az, Am11, Am12, Am13, Am21, Am22, Am23, Am31, Am32, Am33)
end

local function LerpUDim2(a, b, t)
	return UDIM2(
		lerpNum(a.X.Scale, b.X.Scale, t),
		lerpNum(a.X.Offset, b.X.Offset, t),
		lerpNum(a.Y.Scale, b.Y.Scale, t),
		lerpNum(a.Y.Offset, b.Y.Offset, t)
	)
end

local function lerp(a, b, t)
	local objType = typeof(a)
	
	if objType == "CFrame" then
		return LerpCF(a, b, t)
	elseif objType == "number" then
		return lerpNum(a, b, t)
	elseif objType == "Vector2" then
		return LerpVec2(a, b, t)
	elseif objType == "Vector3" then
		return LerpVec3(a, b, t)
	elseif objType == "UDim2" then
		return LerpUDim2(a, b, t)
	end
end

local function getEularAnglesXYZ(cf)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cf:components()
	return Vec3(Atan2(-R12, R22), Asin(R02), Atan2(-R11, R00))
end

--[[function hasReachedMinMag(minMag, object, goal)
	local objType = typeof(object)
	
	if objType == "CFrame" then
		local rotObj = getEularAnglesXYZ(object)
		local posObj = object.p
		
		local rotGoal = getEularAnglesXYZ(goal)
		local posGoal = goal.p
		
		if ((posGoal - posObj).magnitude < minMag) and ((rotGoal - rotObj).magnitude < minMag) then
			return true
		end
	elseif objType == "number" then
		if (goal - object) < minMag then
			return true
		end
	elseif objType == "Vector2" then
		if (goal - object).magnitude < minMag then
			return true
		end
	elseif objType == "Vector3" then
		if (goal - object).magnitude < minMag then
			return true
		end
	end
	
	return false
end]]

local function tweenObject(object, goalObjects, objectIndex, iEased)
	if object.instance:IsA("BasePart") then
		if object.property == "Position" then
			local Ax, Ay, Az, Am11, Am12, Am13, Am21, Am22, Am23, Am31, Am32, Am33 = object.instance.CFrame:components()
			
			object.instance.CFrame = lerp(
				CF(goalObjects[objectIndex].start.x, goalObjects[objectIndex].start.y, goalObjects[objectIndex].start.z, Am11, Am12, Am13, Am21, Am22, Am23, Am31, Am32, Am33), 
				CF(goalObjects[objectIndex].goal.x, goalObjects[objectIndex].goal.y, goalObjects[objectIndex].goal.z, Am11, Am12, Am13, Am21, Am22, Am23, Am31, Am32, Am33), 
				iEased
			)
		elseif object.property == "Rotation" then
			local cfAGoal = CFA(Rad(goalObjects[objectIndex].start.x), Rad(goalObjects[objectIndex].start.y), Rad(goalObjects[objectIndex].start.z))
			local cfBGoal = CFA(Rad(goalObjects[objectIndex].goal.x), Rad(goalObjects[objectIndex].goal.y), Rad(goalObjects[objectIndex].goal.z))
			
			object.instance.CFrame = lerp(
				CF(object.instance.Position.x, object.instance.Position.y, object.instance.Position.z) * cfAGoal, 
				CF(object.instance.Position.x, object.instance.Position.y, object.instance.Position.z) * cfBGoal, 
				iEased
			)
		else
			object.instance[object.property] = lerp(goalObjects[objectIndex].start, goalObjects[objectIndex].goal, iEased)
		end
	else
		object.instance[object.property] = lerp(goalObjects[objectIndex].start, goalObjects[objectIndex].goal, iEased)
	end
end

local function tweenAllObjects(objects, goalObjects, iEased)
	for objectIndex, object in pairs(objects) do
		tweenObject(object, goalObjects, objectIndex, iEased)
	end
end


--# Class Methods
function Tween:play(tweenObjects, goalObjects, firedFrom)
	-- Which update function is used depending on whether the client or server fired the function
	local updateFunc = nil
	if firedFrom == "Client" then updateFunc = RunService.RenderStepped elseif firedFrom == "Server" then updateFunc = RunService.Stepped else updateFunc = "Heartbeat" end
	
	-- Set Tween variables to playing and wait for the delay
	self.objects = tweenObjects
	self.goalObjects = goalObjects
	self.isPlaying = true
	wait(self.delay)
	
	-- After the delay, end animation is it stopped playing for some reason.
	if self.isPlaying == false then return nil end
	
	-- Set default values for tween goals if they don't exist
	for objectIndex, object in pairs(self.objects) do
		if self.goalObjects[objectIndex].start == nil then
			self.goalObjects[objectIndex].start = object.instance[object.property]
		end
	end
	
	-- Tween/change components of objects
	local increment = (self.increment/self.duration)
	
	for i = 0, self.loopCount, 1 do
		if i > 0 then self.isReversed = not self.isReversed	end
		
		for i = 0, 1+increment, increment do
			updateFunc:wait()
			local iOld = i
			if self.isReversed == true then i = 1 - i end
			
			-- Changing i based on the easing function
			local iEased = easingFunctions[self.easingFunction](i)
			
			-- Tween/change the parameters of all objects
			for objectIndex, object in pairs(self.objects) do
				--print(object.instance[object.property])
				
				-- If the animation stops for some reason, stop Tweening
				if self.isPlaying == false then
					return nil
				end
				
				-- End the animation, snap, and set Tween variables back if the min mag is reached
				if self.maxIncrement ~= nil then
					if iOld > self.maxIncrement then
						local finalIncrement = 1
						if self.isReversed == true then
							finalIncrement = 0
						end
		
						if self.snapAtEnd == true then tweenAllObjects(self.objects, self.goalObjects, finalIncrement) end
						self.isPlaying = false
						self.objects, self.goalObjects = nil, nil
						return nil
					end
				end
				--[[if hasReachedMinMag(self.minMagnitude, object.instance[object.property], self.goalObjects[objectIndex].goal) == true then
					self.isPlaying = false
					if self.minSnap == true then
						snapObjects(self.objects, self.goalObjects)
					end
					return nil
				end]]
	
				-- Set the instance property to Tweened increment
				if object.instance:IsA("BasePart") then
					tweenObject(object, self.goalObjects, objectIndex, iEased)
				else
					object.instance[object.property] = lerp(self.goalObjects[objectIndex].start, self.goalObjects[objectIndex].goal, iEased)
				end
				
			end
		end
	end
	
	print(self.isReversed)
	
	local finalIncrement = 1
	if self.isReversed == true then
		finalIncrement = 0
	end
	if self.snapAtEnd == true then tweenAllObjects(self.objects, self.goalObjects, finalIncrement) end
	self.isPlaying = false
	self.objects, self.goalObjects = nil, nil
	
	print("Tween complete")
end

function Tween:stop(canSnap, resetTime)
	self.isPlaying = false
	
	wait(resetTime or 0)
	
	local finalIncrement = 1
	if self.isReversed == true then
		finalIncrement = 0
	end
	if canSnap == true then tweenAllObjects(self.objects, self.goalObjects, finalIncrement) end
	self.objects, self.goalObjects = nil, nil
end


--# Finalize
return Tween
