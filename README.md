# garlic.lua
"Simple" animation library for [LÖVE2D](https://love2d.org/).
This library takes three steps in order for animations to function. Firstly, you create an Actor, which are animated objects in your game that hold and control multiple animations. Then, you create Animations to attach to the Actor, which are sequences of frames. However, before you attach them at all, you must give those Animations some Frames, which are the specific parts of a spritesheet that represent individual frames of animation.

# Actors
Actors are objects that store, manage, and display Animations, which must be attached beforehand. Each actor is tied to a spritesheet (an image containing multiple frames of animation) and can manage multiple animations simultaneously. When an actor is created, it starts without any animations, and they need to be attached individually.

Creating an actor, then giving it some animations:
```lua
local actor = garlic.newActor(spritesheet)
actor.attachAnimation(anim1)
actor.attachAnimation(anim2)
```

Creating an actor only takes in a singular Image argument.

# Animations
Animations are a collection of frames that are played one after another during playback. When an animation is created, it starts as an empty sequence of frames. You must define and attach frames to it manually.

Creating an animation with an ID of "walk", and giving it some frames:
```lua
local walkAnim = garlic.newAnimation("walk", 2, 4, true, false)
walkAnim.attachFrame(frame1)
walkAnim.attachFrame(frame2)
```

Creating an animation requires five arguments (actually, everything beyond the first argument is optional. but still!!).
```lua
.newAnimation(
  "ID", -- The ID of the animation. Note that when attaching this to an actor, that there can't be another pre-existing animation of the same ID.
  2, -- The animation's priority. Animations of higher priority (and are playing) typically get drawn first before any others.
  4, -- How fast the animation is.
  true, -- Whether or not to enable looping. If true, when the animation ends, it will return to the first frame and continue playing.
  false -- Whether or not to enable loopback. Assuming looping is false, the animation will snap back to the first frame and stop playing once it has finished.
)
```

# Frames
A Frame is a singular image of a spritesheet that will be drawn to the screen, and are defined as Quads. They are the most basic unit of an actor.

Creating a frame:
```lua
local frame1 = garlic.newFrame(0, 0, 32, 32)
```

The first two arguments are the X & Y position coordinates of the frame. The other two simply defines its size.

# Functions

