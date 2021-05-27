String errorHandler(String errorCode) {
  switch (errorCode) {
    case "invalid-email":
      return 'Your email address is invalid';
      break;
    case "wrong-password":
      return 'Invalid password! Please try again';
      break;
    case "user-not-found":
      return 'No matching record was found, Please try again';
      break;
    case "user-disabled":
      return 'The account has been disabled and cannot be used';
      break;
    case "too-many-requests":
      return "Too many requests! We hope you're not a bot.";
      break;
    case "operation-not-allowed":
      return "Sorry, you are not permitted to do this";
      break;
    case "email-already-in-use":
      return 'Existing account found. Please login.';
      break;
    case "network-request-failed":
      return 'You are Offline! Please check your connection';
      break;

    default:
      return "Something went wrong, please try again later";
  }
}
