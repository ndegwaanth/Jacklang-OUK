nodeset vec_node {
    has int x
    has int y
}

graph mygraph {
    spawn {
        vec_node a { x=2, y=3 };
        vec_node b { x=4, y=1 };
        vec_node c { x=a.x + b.x, y=a.y + b.y };

        report("Vector A: (" + a.x + ", " + a.y + ")");
        report("Vector B: (" + b.x + ", " + b.y + ")");
        report("A + B = (" + c.x + ", " + c.y + ")");
    }
}


