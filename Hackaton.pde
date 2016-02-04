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
    if (search_input) {
        background(100);
        text(root_input, 10, 30);
    } else {
        cur.display();
    }
}

void keyPressed() {
    if (search_input) { // cas quand on est dans la recherche
        if (key == ENTER) {
            cur = new Node(width/2, height/2, "film", root_input);
            search_input = false;
        } else if (key == BACKSPACE) {
            if(root_input.length() > 0)
                root_input = root_input.substring(0, root_input.length()-1);
        } else {
            //on ajoute une valeur dans la string
            root_input = root_input + key;
        }
    } else if(key == BACKSPACE){ // quand on parcours l'arbre si on appuie sur backspace on reprend l'historique sauf si il est vide
        if(histo.isEmpty()){ //si l'historique est vide on reviens juste a la page d'avant
            search_input = true ;
        }else{//on doit prendre le dernier noeud de l'historique pour le passer en noeud courant
           // et supprimer le dernier élément de la liste de l'histo
           cur = histo.get(histo.size()-1) ;
           histo.remove(histo.size()-1) ;
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