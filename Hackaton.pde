int xoffset, yoffset;
PFont merri_font;
DataManager imdb;
String root_input, titre;
boolean search_input;
Node cur;
ArrayList<Node> histo;

void setup() {
    size(800, 600);
    xoffset = width/2;
    yoffset = 4*height/5;
    merri_font = createFont("Merriweather.ttf", 35);
    textFont(merri_font); textSize(16);
    imdb = new DataManager();
    titre= "Entrez le nom d'un film :";
    root_input = "";
    search_input = true;
    histo = new ArrayList<Node>();
}

void draw(){
    background(#8C80A2);
    println("je suis dans la boucle") ;
    translate(xoffset, yoffset);
    if (search_input) {
        fill(0);
        textSize(35);
        text(titre, -175, 0);
        fill(75);
        text(root_input, -20, 50);
        textSize(16);
    } else { // la on est dans le graphe
        cur.display();
    }
}

void keyPressed() {
    if (search_input) { // saisie de texte pour la racine
        if (key == ENTER) {
            int idFilm = imdb.getId("movie", root_input);
            if (idFilm == -1) {
                println("Movie '"+root_input+"' was not found :(");
               
                return;
            } else {
              cur = new Node(0, 0, "film", imdb.getTitle(idFilm));
              search_input = false;
            }
        } else if (key == BACKSPACE) {
            if (root_input.length() > 0)
                root_input = root_input.substring(0, root_input.length()-1);
        } else { // touche quelconque
            root_input = root_input + key;
        }
    } else {
        if (key == BACKSPACE) { // quand on parcours l'arbre si on appuie sur backspace on reprend l'historique sauf si il est vide
            if (histo.isEmpty()) { //si l'historique est vide on reviens juste a la page d'avant
                println("on est dans laboucle histo vide");
                search_input = true;
            } else {//on doit prendre le dernier noeud de l'historique pour le passer en noeud courant
               // et supprimer le dernier élément de la liste de l'histo
               Node prev = histo.remove(histo.size()-1);
               xoffset -= prev.x - cur.x;
               yoffset -= prev.y - cur.y;
               String type = "person";
               if (cur.type.equals("film"))
                   type = "film";
               cur = prev;
               cur.requestSons(type);
            }
        }
    }
}

void mouseClicked(){
    if (!search_input) {
        if (!cur.sons.isEmpty()) {
            // vérifier qu'on clique sur un fils de cur
            Node clicked = cur.sonClicked(mouseX-xoffset, mouseY-yoffset); 
            if (clicked != null) { // si oui, translation et màj histo
                xoffset += cur.x - clicked.x;
                yoffset += cur.y - clicked.y;
                histo.add(cur);
                cur = clicked;
            }
        }
        if (mouseButton == LEFT)
            cur.requestSons("film");
        else
            cur.requestSons("person");
    }
}