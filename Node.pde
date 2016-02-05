class Node {
  
    float x, y, xoff, yoff;
    String type, value;
    color hcol, border;
    ArrayList<Node> sons;

    Node(float x_, float y_, String type_, String l_){    
        x = x_; y = y_; type = type_; value = l_; xoff= 0.0; yoff= 0.0;
        switch(type){
        case "film":
            hcol = color(#FCCC63);
            border= color(#362201);
            break;
        case "actor":
            hcol = color(#4EFA60);
            border= color(#013610);
            break;
        case "director":
            hcol = color(#628DFF);
            border= color(#011336);
            break;             
       }
        sons= new ArrayList<Node>();
    }

    void display(){
        
        if (!sons.isEmpty())
            for (Node n : cur.sons) {
                strokeWeight(1);
                if(n.hover()) stroke(220);
                else stroke(0);
                line(cur.x, cur.y, n.x, n.y);
                strokeWeight(10);
                n.display();
            }
        if (hover()) fill(hcol);
        else fill (240);
        strokeWeight(8);
        stroke(border);
        ellipse(x, y, 50, 50);
        if(hover()) fill(220);
        else fill(0);
        text(value , x-35, y-35);
    }
    
    boolean hover() {
        return dist(mouseX-xoffset, mouseY-yoffset, x, y) <= 25;
    }
    
    
    void requestSons(String typeA){
        sons = new ArrayList<Node>();
        switch(typeA) {//différencier les 3 cas des noeuds pour pouvoir gerer la couleur des ronds
        case "film":
            int i=0;
            for (String s : imdb.getFilms(type, value)) {
                sons.add(new Node(getSonX(i), getSonY(i), "film", s));
                i++;
            }
            break;
        case "person": 
            if (type.equals("film")) {
                ArrayList<String> persons = imdb.getPersons(type, value);
                for (int j=0; j<persons.size(); j++) {
                    if(j==persons.size()-1) sons.add(new Node(getSonX(j), getSonY(j), "director", persons.get(j)));
                    else sons.add(new Node(getSonX(j), getSonY(j), "actor", persons.get(j)));
                }
            } else {
                int k=0;
                for (String s : imdb.getPersons(type, value)) {
                    sons.add(new Node(getSonX(k), getSonY(k), "actor", s));
                    k++;
                }
            } 
        }
    }
    float getSonX(int i) {
       return x + cos((-i)*PI/8) * (300+(i%2)*75);
    }

    float getSonY(int i) {
       return y + sin((-i)*PI/8) * (300+(i%2)*75);
    }
    
    Node sonClicked(float x1, float y1) {
        for(Node n : sons) {
            if(dist(x1,y1, n.x, n.y) <= 25)
                return n;
        }
        return null;
    }

}