PFont merri_font;
DataManager imdb;
String root_input;
boolean search_input;
Node cur;
ArrayList<Node> histo;

void setup() {
    size(800, 600);
    merri_font = createFont("Merriweather.ttf", 16);
    textFont(merri_font); textSize(16);
    imdb = new DataManager();
    root_input = "";
    search_input = true;
    histo = new ArrayList<Node>();
}

void draw(){
    if (search_input) {
        background(100);
        text(root_input, 10, 30);
    } else { // la on est dans le graphe
        cur.display();
    }
}

void keyPressed() {
    if (search_input) { // cas quand on est dans la recherche
        if (key == ENTER) {
            int idFilm = imdb.getId("movie", root_input);
            if (idFilm == -1) {
                println("Movie '"+root_input+"' was not found :(");
                return;
            }
            cur = new Node(width/2, height/2, "film", imdb.getTitle(idFilm));
            search_input = false;
        } else if (key == BACKSPACE) {
            if(root_input.length() > 0){
                if(histo.isEmpty())
                root_input = root_input.substring(0, root_input.length()-1);
            }
        } else {
            //on ajoute une valeur dans la string
            root_input = root_input + key;
        }
    } else if(key == BACKSPACE) { // quand on parcours l'arbre si on appuie sur backspace on reprend l'historique sauf si il est vide
        if(histo.isEmpty()){ //si l'historique est vide on reviens juste a la page d'avant
            println("on est dans laboucle histo vide") ;
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
        if (!cur.sons.isEmpty()) {
            // vérifier qu'on clique sur un fils de cur
            Node clicked = cur.sonClicked(mouseX, mouseY); 
            if (clicked != null) { // si oui, màj histo et translation
                histo.add(cur);
                cur = clicked;
                // translate blablabla...
            }
        }
        if (mouseButton == LEFT)
            cur.requestSons("film");
        else
            cur.requestSons("person");
    }
}