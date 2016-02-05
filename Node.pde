class Node {
  
    float x, y, xbuf, ybuf;
    int size;
    String type, value;
    color hcol, border;
    boolean dispsons;
    ArrayList<Node> sons;

    Node(float x_, float y_, float xb, float yb, String type_, String l_) {
        xbuf = xb; ybuf = yb;
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
        dispsons = false;
        sons= new ArrayList<Node>();
    }

    void display(){
        float delta;
        if (abs(xbuf) >= 1) {
            delta = xbuf/10;
            x += delta;
            xbuf -= delta;
        } else { xbuf = 0; }
        if (abs(ybuf) >= 1) {
            delta = ybuf/10;
            y += delta;
            ybuf -= delta;
        } else { ybuf = 0; }
        if (!sons.isEmpty() && dispsons)
            for (Node n : cur.sons) {
                strokeWeight(1);
                if(n.hover()) { stroke(220);}
                else stroke(0);
                line(cur.x, cur.y, n.x, n.y);
                strokeWeight(10);
                n.display();
            }
        if (hover()) fill(hcol);
        else fill (#D1C9E0);
        strokeWeight(8);
        stroke(border);
        if(hover()) size=60;
        else size= 50;
        ellipse(x, y, size, size);
        noFill();
        strokeWeight(2);
        stroke(45);
        if (hover()) stroke(220);
        ellipse(x, y, size-5, size-5);
        if(hover()) fill(220);
        else fill(0);
        float yoff = y+70;
        textSize(35);
        if (this != cur) {
            yoff = y-40;
            textSize(18);
        }
        text(value , x-textWidth(value)/2, yoff);
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
        int i, n;
        switch(typeA) {//différencier les 3 cas des noeuds pour pouvoir gerer la couleur des ronds
        case "film":
            ArrayList<String> films = imdb.getFilms(type, value);
            n = films.size();
            for (i=0; i<n; i++) {
                sons.add(new Node(x, y, getSonX(i, n)-x, getSonY(i, n)-y, "film", films.get(i)));
            }
            break;
        case "person": 
            ArrayList<String> persons = imdb.getPersons(type, value);
            n = persons.size();
            for (i=0; i<n; i++) {
                if (i==0 && type.equals("film")) sons.add(new Node(x, y, getSonX(i, n)-x, getSonY(i, n)-y, "director", persons.get(i)));
                else sons.add(new Node(x, y, getSonX(i, n)-x, getSonY(i, n)-y, "actor", persons.get(i)));
            }
        }
    }
    float getSonX(int i, int n) {
       float theta = (float)(-i) - 0.5;
       return x + cos(theta*PI/n) * (2*height/3-random(90));
    }
    float getSonY(int i, int n) {
       float theta = (float)(-i) - 0.5;
       return y + sin(theta*PI/n) * (2*height/3-random(90));
    }
    
    Node sonClicked(float x1, float y1) {
        for(Node n : sons) {
            if(dist(x1,y1, n.x, n.y) <= 25)
                return n;
        }
        return null;
    }

}