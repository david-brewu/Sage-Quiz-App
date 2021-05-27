List<String> shortMonths = [
  "Jan",
  "Feb",
  "March",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

List<String> longMonths = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

int monthName2Number(String name, {zeroBased = false}) {
  name = name.substring(0, 1).toUpperCase() + name.substring(1).toLowerCase();
  if (!zeroBased && longMonths.indexOf(name) != -1)
    return longMonths.indexOf(name) + 1;
  if (zeroBased && longMonths.indexOf(name) != -1)
    return longMonths.indexOf(name);
  if (!zeroBased && shortMonths.indexOf(name) != -1)
    return shortMonths.indexOf(name) + 1;
  if (zeroBased && shortMonths.indexOf(name) != -1)
    return shortMonths.indexOf(name);
  return -1;
}

String monthNumber2Name(int number,
    {String format = "short", zeroBased = false}) {
  /*
  Jan is 1 not 0; if your input is zero based set the zeroBased flag to true
  */
  if (number.isNaN) return "Unknown";
  if (!(format == 'short' || format == "long")) format = "short";
  if (!zeroBased && (number < 1 || number > 12)) return "Unknown";
  if (!zeroBased && (number < 0 || number > 11)) return "Unknown";

  if (format == "short" && zeroBased) return shortMonths[number];
  if (format == "long" && zeroBased) return longMonths[number];
  if (format == "short" && !zeroBased) return shortMonths[number - 1];
  if (format == "long" && !zeroBased) return longMonths[number - 1];
  return "Unknown";
}
