import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
   
  "type": "service_account",
  "project_id": "flutter-gsheets-410919",
  "private_key_id": "9e94106b4bd3fa720b0cfdaf0bf6accb929ed311",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDmAwtdgWIrgVvP\npAmmXf7lSwYM0E8ZUNpLbAqDJVcTd8ZLET/OVFFVEwAXp4PoHk364Qlk0SO/jGGZ\nL9r6/i/FowGhcKks0nF82SURbg9b7xX4NTmiagsO5QTgAZoYtkUYt5VQFr51ln/n\ne74Nk4wrj7B3onOiLwX9cKbHUqXfHoSW5QI4zbg39dlI+QHzaNgwHZDrG1MolNfP\nJFR1G0ZWt24wU2CmAhwbfXCE30XydgcBa63C8PyVJ6Zy3FzCoOJYIOrSCQP/Ilu9\nErlPRcXc1RtRC3t3sYlL2wfkKk0iB89LQIyeVQdrPFjOi0WKMIYgYrcyJqWvJUS4\neypqTvSTAgMBAAECggEAI0zQT7dto5OkzYc1W+0NE4+iDBFkMlRwTCb2rg3rATfe\nnOK20imqmc3is76nxdXwzdH/qRNX0yvuRp5Lkz2zgzdzJp2tuQ1LEYgZ4kTr4oYc\n7wzsHXr823pWdzKHvccrb5GtPq9e55kDZDlff6HnX0AcKyApcviYiL7jOa/7ePRh\nk8ut82DEUnrZ25PyiMISAsHHvx/CQe/THk4MRtTt7WXPAtQSwkTKcsHk3pMlp7iX\ndnpCqpSMc4TWL+NFmlXhLMR83CImGzL3rvz45kASbuFqhEMKofU3PjMmew0I48AZ\njhpD1acBWBli8TyMuI2yT8hHY5Bqvhzs06cfcTRFQQKBgQD1ucsF+krBq9g/Jbl1\naxIEjxJNKMB/+Yp/OtdkURBrLeGPfDVj/vIYNZ0HdsS9dH+J+VWpej5p0Yo+YN8B\nzS12rZ19JFukRjGuBKS/MoJijNr87vgk9FvUN+FgTAnAKO2G7k7JlfTc7Q3RZJyh\nHv6u0c6s/SWj/EBMAI+yus9YEQKBgQDvoQ2FJqt9qu8eEmdahrHgLnZ1EBlThbqn\nOU3W66j/cj8udIJuuK/jiLZSVvKrPOZ5Y9/TML3MB75ZcTIA+Bxv0uOy5KDyck7U\ndcdRVPz+pkOw/zrROAzvEstda8Ajeno0dENqJ7YrbpYX96n5C5W+u7P6bjnO+/OB\nozPtkpeGYwKBgGTofFAjHcn0qOQduNBYPNj0a/6Vqp+jOVXQMx22EHkDKWrEBiTf\nUEnS0n57LoXirnFZm+zyD2ljLFM7crkJqg7fcxot8Rg/3yzoKUN/GX4g+9j8xZhf\nZMp8fCgQcbyg0hIkEOTFmP2Ut6TynUOpN8tQy3/MoUV7VGghnuE1x+oRAoGABxYK\nIk/cbmDppUgCCmlFRU3abufE9/VSabOGG77oRnWIbMVBPijz+pSGX7T2hB3O6vQL\nIGGmmyv3cwmn4uNzY9MmrJmaMNE0h4/cDwmmWZltEwTZJmqz5zX1EZQoIGR0zKxL\neg4mku44Pgky24x+Jx/B2Lv9taM5tjGvTW0yUeUCgYAuya+43IltQeCAxtbr1muj\nSMbEib39typEBVgbWfYReCLNkAyMDYvTnuvBod8IRT8oF708Mk3fF37DCGlTPmd7\nBOj2Y5eze12oZlMGIaRl0ze6MPgBcVQVY8AHTEHjDxp9XVHgJM4yYdTnqzbCaMdx\nN57O0nDyZA49bqr3ZnpqOQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheets@flutter-gsheets-410919.iam.gserviceaccount.com",
  "client_id": "112431157200299513358",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets%40flutter-gsheets-410919.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
  
  }
  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1NY2Rg_6XgCl4zU-0Q7sRZmQgoxvNkPAJRzIZDb7D9E8';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Database');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
        .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
      await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
      await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
      await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
