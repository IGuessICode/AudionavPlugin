# AudionavPlugin
Audio accessibility plugin for Godot v4.5 that automates 3d sound positioning and wayfinding by adding child nodes to interactive objects within the scene. Please note it is tailored for 2d game integration.

# What does the plugin have?
 - Demo Setup Scene to configure the 3d panning, freely customizable to your game´s style.
 - _Keysound_ Resource, to select the audio sample for each type of interactive object, volume in dB, pitch scale and pitch randomness (So every object within the same category is recognizable)
 - Sample interactive object list _KEY_SOUND_PRESET_NAME_
 - _Accessible Audioplayer_ Node, which you can add to the objects you want the player to echolocate.
 - _Audionav Player_ Node, to add to your scene tree so that the _Accessible Audioplayer_ nodes can send the audio streams to the Audionav audio buses.
 - Default _Audionav Profile_ with sample configuration of the audio buses to accurately pan the audio in each direction.

# Import the plugin
To import the plugin to an existing project...
1. Download the repository
2. From the Godot Engine program, drag the AudionavPlugin folder into the the _/addons_ folder in the project´s tree.*
3. Go to _Project > Project Settings > Plugins_ and enable Audionav Plugin by ticking the box.
4. Safe the project and close the engine.
5. Open the project once again and you can resume coding. You will be able to find 4 new buses in the audio bus layout (AudionavLeft, AudionavRight, AudionavFront, AudionavBack); and two new nodes in the _Create a new Node_ window, _Accessible Audioplayer_ and _Audionav Player_.
   
  *Note: Some errors will appear in the cosole since Godot v4.5 has been acknowledged to fail to load autoloads/singletons from plugins before trying to read the other files, which causes dependencies to not be correctly referenced and it gives these "Fail to compile" messages. Upon restart of the engine, the project should load and compile correctly.
