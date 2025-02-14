import 'package:dartz/dartz.dart';
import 'package:music_app/core/usecase/usecase.dart';
import 'package:music_app/domain/repository/auth/auth.dart';
import 'package:music_app/service_locator.dart';

class GetUserUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async{
    return await sl<AuthRepository>().getUser();
  }
  
  
}
