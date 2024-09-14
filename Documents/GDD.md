# RPG Life - Game Design Document

The Main Goal for RPG Life is to connect people in a medieval-fantasy inspired virtual space. The players will be able to pick up a Role of their choosing and advance in their role at their own pace, with the aid of other players. There will be 5 backbones of play: Home/Userspace decoration, advancing through Milestones, playing Mini-games, Connecting with others, and Defeating Bosses. Through these 5 Core activities a cycle of experiences will hopefully flourish.


## The Cycle

Currently, this is not super defined. However the general idea is that Progress in one of the 5 Major Activities will unlock potential progress in the others. An example: Player has grown special Herbs in their Farm, allowing them to make a new Potion which helps them Defeat a Monster which drops new Seeds. 

Another Example but with Multiplayer: Player A has picked up the Warrior and Miner Jobs, where Player B has the Mage and Blacksmith Jobs. Player A has Mined a new mineral, which Player B can now purchase from them. Now Player B can forge a better weapon that Player A could use to defeat a crystal monster. Defeating the Crystal monster means Player A can now harvest Crystal which Player B can Purchase and equip to make stronger magics. Back and forth of enhancing eachother pool of accessible resources and skills to get better gear and new decor.


## The Target Platform

For maximum connectivity potential and to hit the largest possible audience the game will be made for Mobile. Android and iOS specifically. The game will also be Free and Open-Source, so no barriers to entry. The community can take it and make it better if ever needed. Learn from it, or even preserve it. With these set parameters, tools and assets will have to be limited to Free Open Source to prevent licensing conflicts.



## The 4 Games Within

### The Home Builder

The Player will have a 3D UserSpace/Home. It’s important that the player can customize this space as much as they want, and very easily. This Space will also host the Job Stations, which will visually upgrade along with their skill. All player spaces will be floating masses over a backdrop. The Backdrop can be changed and supports various biomes and themes (Jungle, Island, Aquatic, Arctic, Space). The Terrain can be customized separately to the Objects placed upon it. Objects are earned through the Cycle, though some starting ones will be provided. The Player can control an Avatar, running up to objects brings selection bubbles on the screen for interaction.

The Floating Mass will always be a Circle or Cylinder shape. The Area size increases with Level. Customizing the Terrain will basically be a drawable HeightMap, allowing players to quickly brush in hills, ponds, and rivers. Objects will be “prefabs” which can be arranged from an edit mode. They can be dragged-dropped anywhere, as well as rotated on a Y-Axis. Their tilt relative to the Normal of the Terrain can be turned on and off. Their central position will refer to the HeightMap that the Terrain uses to determine position on the Y-Axis. Job Stations will also use this system, however they do not require the Player to approach them to be interacted with.

When Connecting to another player, copies of each other's UserSpace are placed into each other's World. They can be seen in the far off distance, up to a certain amount of them to prevent lag, and with a toggle switch. A Side Menu icon is available, opening it generates a list of the connected players, the resources they have available, and their level. Selecting one of these entries takes the player to that world.

### The Idle RPG

The Player will have 2 Jobs that they choose from in the beginning. As a Player progresses and gains more experience in their Jobs, they will passively gain more resources faster and/or in larger bulk. The Types and Rarities of accessible Resources will expand as they apply themselves to overtake challenges, and complete Milestones within that Job.

When Connecting to another player; a copy of each Player, and their chosen Jobs, will be copied into each other’s World. Players can then purchase Materials and Products from those connected players using Gold/Money.

### Job Mini-Games

The Player can interact with Job Stations to perform various tasks depending on the Job. For Jobs that Gather more than Produce, they can choose to go on Expeditions to search for material from new areas. For Production Jobs, a filterable list of objects will show what can be made, the Crafting Menu. The Player then decides how many they would like to make and devotes the necessary Resources. Then a Mini-Game takes over, and the player has to complete it to earn their Product. Upon failing they are returned to the Crafting Menu along with their Resources. Recipes, and Areas to Explore can be unlocked and expanded by Connecting with other players who have different Jobs, as well as by general Milestone Progression in that Job and defeating Boss Encounters.

The First time a Player successfully crafts something or encounters a new material, it will be unlocked and available to Connected Players. If a Player wants something that a Copy can make, they can visit their world and Craft it from them, though they have to supply the Resources.

### Enemy Combat

Players will have their 2 Jobs and a Combat Role. Combat Roles will function the same as most traditional RPG Classes. The Gameplay Style for Combat will most likely need to be Action Time Battle, or ATB. Located in a Menu Somewhere, will be a massive, updating list of Enemy Boss Encounters. Players can Ready Up in a lobby to fight a Boss, at which point they can choose 4 Player Copies to play as Bots, or Connect with other Friends in person. The Player’s arsenal of Actions is dictated by their Role, 2 Jobs, and Equipment.


## The Visual Design

Target Visual Design is currently Minimal Textures, using Geometry with simple shaders. The General style will be Micro World. Player Avatars will be considerably Large compared to real life. This is subject to change.


## Connecting Players

A Huge part of the game will be Players helping each other, actively and passively. Players Worlds will become more and more populated with various other Player Worlds as they keep connecting to each other. Players will also copy over other copied players, in an almost infectious way. Since mobile devices have limitations on how files are accessed and shared, the Game should have multiple methods of connecting. At minimum, TCP/UDP over Wifi.
