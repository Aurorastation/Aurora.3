# Grab System

There's two parts to the grab system. There's the grab object: /obj/item/grab
and there's the grab datum: /singleton/grab. Each grab datum is a singleton and the
system interacts with the rest of the code base through the grab object.

Each stage of the grab is a child of the grab datum for that grab type. For normal
there's /singleton/grab/normal/passive, /singleton/grab/normal/aggressive etc. and they
get their general behaviours from their parent /singleton/grab/normal.
