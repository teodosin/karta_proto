# Karta

![image](https://github.com/teodosin/karta_proto/assets/31853349/cb24ebd0-fe57-4cec-8471-4fe9bc85c3e5)

Karta, most fundamentally, is intended to be an augmented file browser and allow for visual and conceptual connections to be made between files in the file system.  This makes it potentially a great tool for file and project management, as a sort of in-between layer between other, more specialised software. It would allow compositing and packaging up of some files and data to sequence them into new files. For example, exporting a sequence of image nodes into pdf's or videos. This would provide a great base set of functionality from which Karta can then be specialised into different use cases depending on what there is demand for.

This repository contains the prototype or proof-of-concept for Karta. It was made in the Godot 4 game engine with its internal scripting language GDScript. Therefore a copy of the newest stable version (Godot 4.0.3 as of writing this) is required to edit and run the project. This version is considered to have reached its goal of illustrating the concepts behind Karta and is no longer in active development. If and when the idea is pursued further, the application will be rewritten from scratch (likely not in Godot) to provide a more stable and testable foundation to develop on. 

## Core Features

This prototype implements the a somewhat scattered set of features. They are unpolished and often buggy. Their purpose is to map out the design space for a future iteration of the app, to give a clearer picture of what the desired architecture should be. 

#### Keyboard shortcuts

F - Focal tool
G - Move tool
T - Transition tool
E - Edges tool
D - Draw tool

TAB - New node menu

P - Toggle performance mode

X - delete node (warning: buggy)

F5 - Toggle node debug info
F6 - Toggle display of node names

#### Core tools

The current active tool determines what clicking with the mouse does. 

* Focal - clicking on a node sets it as the focal node and moves into its context or local graph. Nodes are despawned, spawned and moved accordingly. 
* Move - clicking and dragging on a node moves it. This updates its relative position in its connection to the Focal. If the Focal is moved, all connected node positions are updated relative to it. 
* Edges - clicking and dragging from one node to another creates a new edge between them. The type and group of the edge is defined in the pop-up menu under the tools panel. 
* Transition - moves into a Focal context, but only if there is an edge of type "transition" connecting them. More on this feature below. 
* Draw - draw rectangles into the scene layer. More on this below. 


#### Focal Nodes

The basic structure of Karta is that it is a view into a directed graph, made of nodes and edges. The network is always viewed from the context or point-of-view of a single node, displaying that node and its connections with one layer of depth. Like a local graph.

Nodes don't have an absolute position: instead, their position in the graph is always defined as a relative position to the current Focal node. These relative positions are stored in the edges between nodes. This means that the Focal node, the focal point of whichever context you are in, always sets the positions of its connections. 

The aim of this feature is flexibility and reusability. Depending on what you're working on, you might want to organise existing nodes in different arrangements, yet it's preferable to not have to duplicate nodes to do this. Relative positions allow for the reuse of nodes in vastly different layouts, and for nodes to always know the contexts in which they are used and relevant. 

#### Basic Node Types

The most basic node is a Base Node. It contains no data except the data common to all nodes, such as the node name. 

The other two most basic nodes are the Text and Image nodes. Both of these are resizable. The Text node is just a text box for writing (non-rich) text. The Image node specifies a path in the file system to an image and then loads and displays that image. These two nodes illustrate how Karta could also be used as a digital whiteboard or canvas, for laying out visuals and text in a dynamic way. 

#### Edges, the connections between Nodes

Edges between nodes can be one of three different types, which change how they are treated by the app. 
* Base - generic, two-way connections
* Parent - establish a hierarchical connection between two nodes. Only implemented for Scenes and Rectangles. 
* Transition - mark an edge as a transition. More on this in the section about Transitions. 

Edges can also have a group, which can be any text. These currently do nothing, but the intended use is for filtering. In a future version it might be better to just allow arbitrary attributes on all edges.

#### Performance mode

When Performance mode is on, the current active Focal node will have its data displayed in a separate view. In this case, the graph background. The ability to display this in a separate window was planned for this prototype, but is apparently not something supported by the game engine. You will have to imagine it. 

Currently this is implemented for Image and Scene nodes. If an Image node is set as the Focal, that image will be displayed in a different view. If a Scene node is set as the Focal, it will display all of its child ObjectRectangles. 

#### Scenes, Rectangles and Transitions

This is an experimental feature developed during a course on Interactive and Immersive Art. Turning Karta into a state machine. 

Scenes display their children rectangles in the performance view. Each Scene is therefore a state, an arrangement in which a set of objects exist. If a transition edge is defined between two Scenes, moving between them using the Transition tool will smoothly animate the rectangles between two states. If there is an uneven amount of rectangles, the excess will be faded out or in.

The Draw tool can be used to automatically create these rectangle nodes by drawing them in the graph background. Click and drag to create a rectangle, and the corresponding node will be added to the graph automatically. 

There is also a Properties node, which displays the data of whatever other node is currently selected. When selecting a rectangle, the Properties node displays the position and size of it and allows manual editing. The update isn't instantaneous. The rectangle will update when another rectangle is created of when the user reenters the current context. 

#### Other notes

* Nodes and edges are stored in the default appdata folder in Godot's resource ( .tres) format. 
* There exists a bug where sometimes a node's edge index gets erased, and its connections are no longer spawned when they are supposed to. This has proven to be very hard to debug and is not worth fixing at this point, because this prototype is not meant to be used for serious work anyway. Saving nodes is therefore disabled. 

## Future work

Written on 25.5.2023.

As mentioned before, this iteration of Karta is no longer in active development. The foundations are shaky and hacked together and have proven, during the last couple feature implementations, to not be scalable. And as much as I love Godot, I've come to believe that it might not be the best tool to make Karta with.

However, I am quite excited about the ideas present here. The local graph based interface and way of working, I believe, lends itself very elegantly to many use-cases. It is universal enough to be extendable to many domains, as I hope the state machine feature shows. It feels like a more intuitive way to work with data, in a way that more closely models how ideas flow in the mind and how patterns are constructed. At least for me. 
