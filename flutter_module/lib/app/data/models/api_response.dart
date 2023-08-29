// this will return a class which contains
// True/false: to determine the color and style of snackbar
// message: to be shown in the snackbar
class APIResponseModel {
  //*================================ Properties ===============================
  final bool succeeded;
  final dynamic data;
  final String? statusCode;
  //*================================ Constructor ==============================
  const APIResponseModel({
    required this.succeeded,
    required this.data,
    this.statusCode,
  });
  //*===========================================================================
}
