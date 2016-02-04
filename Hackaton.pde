PFont merri_font;
DataManager imdb;
String root_input = "";
boolean new_char;
boolean delete_char;
boolean search_input;
boolean expanded;
Node cur;
ArrayList<Node> histo;

void setup() {
    size(800, 600, P2D);
    merri_font = createFont("Merriweather.ttf", 16);
    textFont(merri_font); textSize(16);
    search_input = true;
    new_char = false;
    delete_char = false;
    expanded = false;
    imdb = new DataManager();
    histo = new ArrayList<Node>();
}

void draw(){
    background(100);
    if (search_input) {
        text(root_input, 10, 30);
    } else {
        cur.display();
        if (!expanded){
            if(cur.x> 250) cur.x-=1;
            else{ cur.x+=1;}
            if(cur.y< 375) cur.y+=1;
        } else {
            for (Node n : cur.sons) {
                strokeWeight(1);
                line(cur.x, cur.y, n.x, n.y);
                strokeWeight(10);
                n.display();
            }
        }
    }
}

void keyPressed() {
    if (search_input) {
        if (key == ENTER) {
            cur = new Node(250, 375, "film", root_input);
            search_input = false;
        } else if (key == BACKSPACE) {
            if(root_input.length() > 0)
                root_input = root_input.substring(0, root_input.length()-1);
        } else {
            //on ajoute une valeur dans la string
            root_input = root_input + key;
        }
    }
}

void mouseClicked(){
    if (!search_input) {
        if (!expanded) {
            if (mouseButton == LEFT)
                cur.requestSons("film");
            else
                cur.requestSons("person");
            expanded = true;
        } else {
            if(mouseButton == LEFT) {
                Node clicked = cur.sonClicked(mouseX, mouseY); 
                if (clicked != null) {
                    histo.add(cur);
                    cur = clicked;
                    expanded=false;
                }
            }
        }
    }
}