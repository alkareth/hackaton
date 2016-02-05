float xoffset, yoffset;
float xbuf, ybuf;
PFont merri_font;
DataManager imdb;
String root_input;
boolean search_input;
Node cur;
ArrayList<Node> histo;

void setup() {
    fullScreen();
    frameRate(40);
    xoffset = width/2;
    yoffset = 4*height/5;
    xbuf = 0; ybuf = 0;
    merri_font = createFont("Merriweather.ttf", 35);
    textFont(merri_font);
    imdb = new DataManager();
    root_input = "";
    search_input = true;
    histo = new ArrayList<Node>();
}

void draw(){
    background(#8C80A2);
    float delta = 0;
    if (abs(xbuf) >= 1) {
        delta = xbuf/10;
        xoffset += delta;
        xbuf -= delta;
    } else { xbuf = 0; }
    if (abs(ybuf) >= 1) {
        delta = ybuf/10;
        yoffset += delta;
        ybuf -= delta;
    } else { ybuf = 0; }
    if (cur != null && xbuf == 0 && ybuf == 0) cur.dispsons = true;
    translate(xoffset, yoffset);
    textSize(14);
    fill(85);
    String legende = "Clic gauche : films liés      Clic droit : artistes liés";
    text(legende, -textWidth(legende)/2, 100);
    if (search_input) {
        fill(0);
        textSize(35);
        String prompt = "Mais si, tu sais, ce film...";
        text(prompt, -textWidth(prompt)/2, -40);
        noFill();
        stroke(75);
        rect(-width/4, 0, width/2, 60, 5);
        fill(85);
        text(root_input, -textWidth(root_input)/2, 40);
        textSize(16);
    } else { // la on est dans le graphe
        float xdir = 0, ydir = 400;
        if (!histo.isEmpty()) {
            xdir = histo.get(histo.size()-1).x;
            ydir = histo.get(histo.size()-1).y;
        }
        xdir += (xdir - cur.x) * 10;
        ydir += (ydir - cur.y) * 10;
        line(cur.x, cur.y, xdir, ydir);
        cur.display();
    }
}

void keyPressed() {
    if (search_input) { // saisie de texte pour la racine
        if (key == ENTER) {
            int idFilm = imdb.getId("movie", root_input);
            if (idFilm == -1) {
                println("Movie '"+root_input+"' was not found :(");
                root_input = "";
            } else {
              cur = new Node(0, 400, 0, -400, "film", imdb.getTitle(idFilm));
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
                root_input="" ;
                search_input = true;
            } else {//on doit prendre le dernier noeud de l'historique pour le passer en noeud courant
               // et supprimer le dernier élément de la liste de l'histo
               Node prev = histo.remove(histo.size()-1);
               xbuf = cur.x - prev.x;
               ybuf = cur.y - prev.y;
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
                xbuf = cur.x - clicked.x;
                ybuf = cur.y - clicked.y;
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