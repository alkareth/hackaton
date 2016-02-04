class DataManager {
   
   HashMap<String, Integer> knownIds;
   HashMap<String, ArrayList<String>> knownFilms;
   HashMap<String, ArrayList<String>> knownPersons;
    
   DataManager() {
       knownIds = new HashMap<String, Integer>();
       knownFilms = new HashMap<String, ArrayList<String>>();
       knownPersons = new HashMap<String, ArrayList<String>>();
   }
   
   int getId(String type, String search) { // type = movie | person
       if (knownIds.containsKey(type+search))
           return knownIds.get(type+search);
       JSONObject query = loadJSONObject("https://api.themoviedb.org/3/search/"
           +type+"?api_key=2dc10db31d0e0daea621af965984aafd&query="
           +search.replace(" ", "%20"));
       if (query.getInt("total_results") == 0)
           return -1;
       int id = query.getJSONArray("results").getJSONObject(0).getInt("id");
       knownIds.put(type+search, id);
       return id;
   }
   
   String getDirector(String film) {
       int idFilm = getId("movie", film);
       JSONArray query = loadJSONObject("https://api.themoviedb.org/3/movie/"
           +idFilm+"/credits?api_key=2dc10db31d0e0daea621af965984aafd").getJSONArray("crew");
       for (int i=0; i<query.size(); i++) {
           JSONObject person = query.getJSONObject(i);
           if (person.getString("job").equals("Director"))
               return person.getString("name");
       }
       return "";
   }
   
   ArrayList<String> getFilms(String nodeType, String value) {
       // case "actor": filmography of given actor
       // case "director": idem for director
       // case "film": films by the same director
       if (knownFilms.containsKey(nodeType+value))
           return knownFilms.get(nodeType+value);
       String role = "crew";
       if (nodeType.equals("actor"))
           role = "cast";
       String person = value;
       if (nodeType.equals("film"))
           person = getDirector(value);
       // API communication
       ArrayList<String> ret = new ArrayList<String>();
       int idPerson = getId("person", person);
       JSONObject query = loadJSONObject("https://api.themoviedb.org/3/person/"
           +idPerson+"/movie_credits?api_key=2dc10db31d0e0daea621af965984aafd");
       JSONArray films = query.getJSONArray(role);
       for (int i=0; i<films.size(); i++) {
           if (ret.size() >= 8)
               break;
           JSONObject film = films.getJSONObject(i);
           if ( role.equals("cast") ||
                   (role.equals("crew") && film.getString("job").equals("Director")) )
               ret.add(film.getString("title"));
       }
       knownFilms.put(nodeType+value, ret);
       return ret;
   }
    
   ArrayList<String> getPersons(String nodeType, String value) {
       if (knownPersons.containsKey(nodeType+value))
           return knownPersons.get(nodeType+value);
       ArrayList<String> persons = new ArrayList<String>();
       switch (nodeType) {
       case "actor": // most costarred-actors
       case "director": // favourite actors
           ArrayList<String> films = getFilms(nodeType, value);
           HashMap<String, Integer> actors = new HashMap<String, Integer>();
           for (String title : films) {
               int id = getId("movie", title);
               JSONArray query = loadJSONObject("https://api.themoviedb.org/3/movie/"
                   +id+"/credits?api_key=2dc10db31d0e0daea621af965984aafd").getJSONArray("cast");
               for (int i=0; i<query.size(); i++) {
                   JSONObject person = query.getJSONObject(i);
                   int nb_occ = 1;
                   if (actors.containsKey(person.getString("name")))
                       nb_occ += actors.get(person.getString("name"));
                   actors.put(person.getString("name"), nb_occ);
               }
           }
           ArrayList<String> sorted_actors = new ArrayList<String>();
           for (String cur_a : actors.keySet()) {
               int i;
               for (i=0; i<sorted_actors.size(); i++) {
                   if (actors.get(cur_a) > actors.get(sorted_actors.get(i)))
                       break;
               }
               sorted_actors.add(i, cur_a);
           }
           for (int i=0; i<sorted_actors.size(); i++) {
               if (persons.size() >= 8)
                   break;
               persons.add(sorted_actors.get(i));
           }
           break;
       case "film": // actors + director
           int idFilm = getId("movie", value);
           JSONObject query = loadJSONObject("https://api.themoviedb.org/3/movie/"
               +idFilm+"/credits?api_key=2dc10db31d0e0daea621af965984aafd");
           JSONArray crew = query.getJSONArray("crew");
           for (int i=0; i<query.size(); i++) {
               JSONObject person = crew.getJSONObject(i);
               if (person.getString("job").equals("Director")) {
                   persons.add(person.getString("name"));
                   break;
               }
           }
           JSONArray cast = query.getJSONArray("cast");
           for (int i=0; i<cast.size(); i++) {
               if (persons.size() >= 8)
                   break;
               persons.add(cast.getJSONObject(i).getString("name"));
           }
       }
       knownPersons.put(nodeType+value, persons);
       return persons;
   }
   
}