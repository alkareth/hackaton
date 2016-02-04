class Node {
  
    float x, y;
    String type, value;
    ArrayList<Node> sons;

    Node(float x_, float y_, String type_, String l_){    
        x = x_; y = y_; type = type_; value = l_;
        sons= new ArrayList<Node>();
    }

    void display(){
        fill(200);
        strokeWeight(10);
        ellipse(x, y, 50, 50);
        fill(0);
        text(value , x-35, y-35);
        if (!sons.isEmpty())
            for (Node n : cur.sons) {
                strokeWeight(1);
                line(cur.x, cur.y, n.x, n.y);
                strokeWeight(10);
                n.display();
            }
    }
    
    void requestSons(String typeA){
        switch(typeA) {
        case "film":
            int i=0;
            for (String s : imdb.getFilms(type, value)) {
                sons.add(new Node(x + cos(-i*PI/8) * (150+(i%2)*50), y+ sin(-i*PI/8) * (200+(i%2)*50), "film", s));
                i++;
            }
            break;
        case "person": 
            if (type.equals("actor")) {
                int j=0;
                for (String s : imdb.getPersons(type, value)) {
                    if(j==0) sons.add(new Node(x + cos(-j*PI/8) * (150+(j%2)*50), y+ sin(-j*PI/8) * (200+(j%2)*50), "director", s));
                    sons.add(new Node(x + cos(-j*PI/8) * (150+(j%2)*50), y+ sin(-j*PI/8) * (200+(j%2)*50), "actor", s));
                    j++;
                }
            } else {
                int k=0;
                for (String s : imdb.getPersons(type, value)) {
                    sons.add(new Node(x + cos(-k*PI/8) * (150+(k%2)*50), y+ sin(-k*PI/8) * (200+(k%2)*50), "actor", s));
                    k++;
                }
            } 
        }
    }
  
    Node sonClicked(float x1, float y1) {
        for(Node n : sons) {
            if(dist(x1,y1, n.x, n.y) <= 25)
                return n;
        }
        return null;
    }

}