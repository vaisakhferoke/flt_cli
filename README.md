dart create -t console flt_cli 


dart pub global activate --source path "D:\Flutter Projects\cli\flt_cli"


flt_cli create page:home

dart pub global deactivate flt_cli
dart pub global activate --source path "D:\Flutter Projects\cli\flt_cli"


dart run bin/flt_cli.dart create page:home1/new

dart pub publish