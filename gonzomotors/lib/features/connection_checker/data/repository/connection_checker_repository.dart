

import '../../../../core/network/base_repository.dart';

abstract class ConnectionCheckerRepository extends BaseRepository {
  ConnectionCheckerRepository(super.dio);
}


class ConnectionCheckerRepositoryImpl extends ConnectionCheckerRepository {
  ConnectionCheckerRepositoryImpl(super.dio);
}