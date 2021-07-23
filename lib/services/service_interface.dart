abstract class ServiceInterface {
  /// 서비스 상태 확인
  get isRunning;

  /// 서비스 시작
  void run();

  /// 서비스 종료
  void stop();
}
