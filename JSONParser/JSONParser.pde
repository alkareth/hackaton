float x, y;

void setup() {
    size(640, 480);
    x = width/2; y = height/2;
    JSONObject query = new JSONObject("https://api.themoviedb.org/3/"
           +"search/movie?api_key=2dc10db31d0e0daea621af965984aafd&query="
           +"The Big Lebowski".replace(" ", "%20"));
    println(query.getInt("total_results"));
}

void draw() {
    background(90);
    float dx = mouseX - x;
    float dy = mouseY - y;
    x += dx / 4; y += dy / 4;
    stroke(220);
    fill(140);
    ellipse(x, y, 100+random(abs(dx)/4, abs(dx)/3), 100+random(abs(dy)/4, abs(dy)/3));
}

class Token { String type, value; Token(String t, String v) { type=t; value=v; } } // type = int, string, bool, brack, curl, comma, colon
Token next(String str) { return new Token("", ""); }

class JSONObject {
    
    HashMap<String, Integer> ints;
    HashMap<String, String> strings;
    HashMap<String, Boolean> booleans;
    HashMap<String, JSONArray> arrays;
    HashMap<String, JSONObject> objects;
    
    JSONObject(String url) {
        String json = trim(join(loadStrings(url), ""));
        if (json.charAt(0) != '{')
            exit();
        json = trim(json.substring(1));
        Token tok;
        while ((tok = next(json)).type != "endbrace") {
            if (tok.type != "string")
                exit();
            String key = tok.value;
            json = trim(json.substring(key.length()));
            tok = next(json);
            if (tok.type != "colon")
                exit();
            json = trim(json.substring(1));
            tok = next(json);
            String value = "";
            switch (tok.type) {
            case "int":
            case "string":
            case "boolean":
            case "array":
            case "object":
            }
            json = trim(json.substring(value.length()));
            tok = next(json);
            if (tok.type != "comma")
                exit();
            json = trim(json.substring(1));
        }
    }
    
    int getInt(String key) {
        return 0;
    }

}

class JSONArray {
    
    ArrayList<Integer> ints;
    ArrayList<String> strings;
    ArrayList<Boolean> booleans;
    ArrayList<JSONArray> arrays;
    ArrayList<JSONObject> objects;
    
    JSONArray(String json) {
        
    }

}