import 'package:mysql1/mysql1.dart';

class DatabaseConfig{
   static String host= 'localhost', user = 'root', password ='', db='todolist';
   static int port = 3307;
   DatabaseConfig();

   Future<MySqlConnection> getConnection() async{
      var settings = ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: db,
      );
      return await MySqlConnection.connect(settings);
   }

}