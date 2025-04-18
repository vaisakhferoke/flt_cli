  import 'package:flt_cli/app/constants/strings.dart';
  import 'package:dartz/dartz.dart';
  import 'package:flt_cli/app/core/failure/failure.dart';
  import 'package:flt_cli/app/data/network/network_api_services.dart';
  import 'package:flt_cli/app/data/model/api_model.dart';

  class TestRepository extends NetworkApiServices {
    static String baseUrl = kBaseUrl;

    // Add endpoints here
    static String view = '$baseUrl/view';
  }
  