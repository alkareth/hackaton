class Node {
  
    float x, y, xoff, yoff;
    int size;
    String type, value;
    color hcol, border;
    ArrayList<Node> sons;

    Node(float x_, float y_, String type_, String l_){    
        x = x_; y = y_; type = type_; value = l_; size=50;
        switch(type){
        case "film":
            hcol = color(#FCE1A8);
            border= color(#EA9D02);
            break;
        case "actor":
            hcol = color(#C4FFB4);
            border= color(#407C3D);
            break;
        case "director":
            hcol = color(#CEDBFF);
            border= color(#6081D8);
            break;             
       }
        sons= new ArrayList<Node>();
    }

    void display(){
        
        if (!sons.isEmpty())
            for (Node n : cur.sons) {
                strokeWeight(1);
                if(n.hover()) { stroke(220);}
                else stroke(0);
                line(cur.x, cur.y, n.x, n.y);
                strokeWeight(10);
                n.display();
            }
        
        if (hover()) fill(hcol);
        else fill (255);
        strokeWeight(8);
        stroke(border);
        if(hover()) size=60;
        else size= 50;
        ellipse(x, y, size, size);
        noFill();
        strokeWeight(2);
        stroke(45);
        ellipse(x, y, size-5, size-5);
        if(hover()) fill(220);
        else fill(0);
        text(value , x-35, y-35);
    }
    
    //void move(){
    //  //if(xoff>10) xoff= 0;
    //  //if(yoff>10) yoff= 0;
    //  xoff+= 0.01;
    //  yoff+= 0.01;
    //  float d= noise(xoff) * 50;
    //  x+= d;
    //  print(d);
    //  y+= noise(yoff);
    //}
      
    
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