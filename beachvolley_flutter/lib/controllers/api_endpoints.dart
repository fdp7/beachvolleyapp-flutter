class ApiEndpoints{
  static String baseUrl = "https://beachvolley-api.onrender.com";
  static String loginEndpoint = "/player/login";
  static String registerPlayerEndpoint = "/player/signup";
  static String getPlayerEndpoint = "/player/{:name}"; // DA CAPIRE COME SCRIVERE IN DART I QUERY PARAMETERS NELL'ENDPOINT
  static String getMatchesEndpoint = "/matches";
  static String addMatchEndpoint = "/match";
  static String deleteMatchEndpoint = "/match";
  static String getRankingEndpoint = "/ranking";
}