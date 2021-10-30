//@dart=2.9
import 'package:http/http.dart' as http;
class DiContainer {
  /// Typeをキーにするのがみそ
  static final Map<Type, Object Function()> _container = {};

  /// シングルトン
  static final DiContainer _singleton = DiContainer._();
  factory DiContainer() {
    return _singleton;
  }
  DiContainer._();

  /// インスタンスの生成方法を登録
  bind<T>(T Function() bind) {
    _container[T] = bind;
  }

  /// シングルトン登録
  singleton<T>(T singleton) {
    _container[T] = () => singleton;
  }

  // T型のインスタンスを自動で作成
  T make<T>() => _container[T]();
}

class Hoge{
  String getHoge() => "hoge";
}

class Api{
  Future<String> getJsonData() async{
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));
    return response.body;
  }
}
class ApiMock implements Api{
  @override
  Future<String> getJsonData() async{
    return '{"userId": 1,"id": 1,"title": "delectus aut autemこれはデバックモード this is debug mode","completed": false}';
  }
}