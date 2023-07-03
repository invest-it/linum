const translationKeys = (
  academyScreen: (
    labelButton: 'academy_screen.label-button',
    labelDescription: 'academy_screen.label-description',
    labelTitle: 'academy_screen.label-title'
  ),
  actionLip: (
    forgotPassword: (
      loggedIn: (
        buttonSubmit: 'action_lip.forgot-password.logged-in.button-submit',
        labelDescription:
            'action_lip.forgot-password.logged-in.label-description',
        labelTitle: 'action_lip.forgot-password.logged-in.label-title'
      ),
      loggedOut: (
        buttonSubmit: 'action_lip.forgot-password.logged-out.button-submit',
        labelDescription:
            'action_lip.forgot-password.logged-out.label-description',
        labelTitle: 'action_lip.forgot-password.logged-out.label-title'
      )
    ),
    standardCategory: (
      expenses: (
        labelTitle: 'action_lip.standard-category.expenses.label-title'
      ),
      income: (labelTitle: 'action_lip.standard-category.income.label-title')
    ),
    standardCurrency: (labelTitle: 'action_lip.standard-currency.label-title')
  ),
  alertdialog: (
    deleteAccount: (
      action: 'alertdialog.delete-account.action',
      cancel: 'alertdialog.delete-account.cancel',
      message: 'alertdialog.delete-account.message',
      title: 'alertdialog.delete-account.title'
    ),
    error: (
      actionStandard: 'alertdialog.error.action-standard',
      messageStandard: 'alertdialog.error.message-standard',
      titleStandard: 'alertdialog.error.title-standard'
    ),
    killswitchChange: (
      action: 'alertdialog.killswitch-change.action',
      cancel: 'alertdialog.killswitch-change.cancel',
      message: 'alertdialog.killswitch-change.message',
      title: 'alertdialog.killswitch-change.title'
    ),
    killswitchInitialize: (
      action: 'alertdialog.killswitch-initialize.action',
      cancel: 'alertdialog.killswitch-initialize.cancel',
      message: 'alertdialog.killswitch-initialize.message',
      title: 'alertdialog.killswitch-initialize.title'
    ),
    killswitchRecall: (
      action: 'alertdialog.killswitch-recall.action',
      cancel: 'alertdialog.killswitch-recall.cancel',
      message: 'alertdialog.killswitch-recall.message',
      title: 'alertdialog.killswitch-recall.title'
    ),
    login: (
      actionStandard: 'alertdialog.login.action-standard',
      titleStandard: 'alertdialog.login.title-standard'
    ),
    loginVerification: (
      action: 'alertdialog.login-verification.action',
      message: 'alertdialog.login-verification.message',
      title: 'alertdialog.login-verification.title'
    ),
    resetPassword: (
      action: 'alertdialog.reset-password.action',
      message: 'alertdialog.reset-password.message',
      title: 'alertdialog.reset-password.title'
    ),
    signupVerification: (
      action: 'alertdialog.signup-verification.action',
      message: 'alertdialog.signup-verification.message',
      title: 'alertdialog.signup-verification.title'
    ),
    updatePassword: (
      action: 'alertdialog.update-password.action',
      message: 'alertdialog.update-password.message',
      title: 'alertdialog.update-password.title'
    )
  ),
  auth: (
    claimsTooLarge: 'auth.claims-too-large',
    emailAlreadyExists: 'auth.email-already-exists',
    emailAlreadyInUse: 'auth.email-already-in-use',
    idTokenExpired: 'auth.id-token-expired',
    idTokenRevoked: 'auth.id-token-revoked',
    insufficientPermission: 'auth.insufficient-permission',
    internalError: 'auth.internal-error',
    invalidArgument: 'auth.invalid-argument',
    invalidClaims: 'auth.invalid-claims',
    invalidContinueUri: 'auth.invalid-continue-uri',
    invalidCreationTime: 'auth.invalid-creation-time',
    invalidCredential: 'auth.invalid-credential',
    invalidDisabledField: 'auth.invalid-disabled-field',
    invalidDisplayName: 'auth.invalid-display-name',
    invalidEmail: 'auth.invalid-email',
    invalidEmailVerified: 'auth.invalid-email-verified',
    invalidIdToken: 'auth.invalid-id-token',
    invalidLastSignInTime: 'auth.invalid-last-sign-in-time',
    invalidOauthResponsetype: 'auth.invalid-oauth-responsetype',
    invalidPassword: 'auth.invalid-password',
    invalidPhoneNumber: 'auth.invalid-phone-number',
    invalidPhotoUrl: 'auth.invalid-photo-url',
    invalidSessionCookieDuration: 'auth.invalid-session-cookie-duration',
    invalidUid: 'auth.invalid-uid',
    missingAndroidPkgName: 'auth.missing-android-pkg-name',
    missingContinueUri: 'auth.missing-continue-uri',
    missingIosBundleId: 'auth.missing-ios-bundle-id',
    missingOauthClientSecret: 'auth.missing-oauth-client-secret',
    missingUid: 'auth.missing-uid',
    networkRequestFailed: 'auth.network-request-failed',
    notLoggedInToUpdatePassword: 'auth.not-logged-in-to-update-password',
    notLoggedInToVerify: 'auth.not-logged-in-to-verify',
    operationNotAllowed: 'auth.operation-not-allowed',
    phoneNumberAlreadyExists: 'auth.phone-number-already-exists',
    projectNotFound: 'auth.project-not-found',
    requiresRecentLogin: 'auth.requires-recent-login',
    sessionCookieExpired: 'auth.session-cookie-expired',
    sessionCookieRevoked: 'auth.session-cookie-revoked',
    tooManyRequests: 'auth.too-many-requests',
    uidAlreadyExists: 'auth.uid-already-exists',
    unauthorizedContinueUri: 'auth.unauthorized-continue-uri',
    unknown: 'auth.unknown',
    userDisabled: 'auth.user-disabled',
    userNotFound: 'auth.user-not-found',
    weakPassword: 'auth.weak-password',
    wrongPassword: 'auth.wrong-password'
  ),
  budgetScreen: (
    buttonFilter: 'budget_screen.button-filter',
    labelAllTransactions: 'budget_screen.label-all-transactions'
  ),
  currency: (
    error: (notFound: 'currency.error.not-found'),
    name: (
      aud: 'currency.name.aud',
      blr: 'currency.name.blr',
      cad: 'currency.name.cad',
      chf: 'currency.name.chf',
      cny: 'currency.name.cny',
      czk: 'currency.name.czk',
      dkk: 'currency.name.dkk',
      eur: 'currency.name.eur',
      gbp: 'currency.name.gbp',
      idr: 'currency.name.idr',
      ils: 'currency.name.ils',
      inr: 'currency.name.inr',
      isk: 'currency.name.isk',
      jpy: 'currency.name.jpy',
      krw: 'currency.name.krw',
      mxn: 'currency.name.mxn',
      myr: 'currency.name.myr',
      nok: 'currency.name.nok',
      nzd: 'currency.name.nzd',
      pln: 'currency.name.pln',
      sek: 'currency.name.sek',
      thb: 'currency.name.thb',
      tyr: 'currency.name.tyr',
      usd: 'currency.name.usd',
      zar: 'currency.name.zar'
    )
  ),
  enterScreen: (
    entryTypeSelection: (title: 'enter_screen.entry-type-selection.title'),
    inputFlag: (
      category: 'enter_screen.input_flag.category',
      repeatInfo: 'enter_screen.input_flag.repeat_info',
      date: 'enter_screen.input_flag.date'
    ),
    date: (
      monday: 'enter_screen.date.monday',
      tuesday: 'enter_screen.date.tuesday',
      wednesday: 'enter_screen.date.wednesday',
      thursday: 'enter_screen.date.thursday',
      friday: 'enter_screen.date.friday',
      saturday: 'enter_screen.date.saturday',
      sunday: 'enter_screen.date.sunday'
    ),
    repeat: (
      thirtyDays: 'enter_screen.repeat.thirty_days',
      annually: 'enter_screen.repeat.annually',
      daily: 'enter_screen.repeat.daily',
      freeselect: 'enter_screen.repeat.freeselect',
      monthly: 'enter_screen.repeat.monthly',
      none: 'enter_screen.repeat.none',
      quarterly: 'enter_screen.repeat.quarterly',
      semiannually: 'enter_screen.repeat.semiannually',
      weekly: 'enter_screen.repeat.weekly',
      custom: 'enter_screen.repeat.custom'
    ),
    specialDate: (
      yesterday: 'enter_screen.special_date.yesterday',
      tomorrow: 'enter_screen.special_date.tomorrow',
      today: 'enter_screen.special_date.today'
    ),
    addAmount: (
      dialogLabelTitle: 'enter_screen.add-amount.dialog-label-title',
      dialogLabelTitleExpenses:
          'enter_screen.add-amount.dialog-label-title-expenses',
      dialogLabelTitleIncome:
          'enter_screen.add-amount.dialog-label-title-income'
    ),
    button: (
      expensesLabel: 'enter_screen.button.expenses-label',
      incomeLabel: 'enter_screen.button.income-label',
      saveNote: 'enter_screen.button.save-note',
      close: 'enter_screen.button.close'
    ),
    changeEntry: (
      dialogLabelChange: 'enter_screen.change-entry.dialog-label-change'
    ),
    menu: (
      category: 'enter_screen.menu.category',
      currency: 'enter_screen.menu.currency',
      date: 'enter_screen.menu.date',
      repeatConfig: 'enter_screen.menu.repeat-config',
      notes: 'enter_screen.menu.notes'
    ),
    enterNoteHint: 'enter_screen.enter-note-hint',
    deleteEntry: (
      dialogButtonCancel: 'enter_screen.delete-entry.dialog-button-cancel',
      dialogButtonDelete: 'enter_screen.delete-entry.dialog-button-delete',
      dialogLabelDelete: 'enter_screen.delete-entry.dialog-label-delete',
      dialogLabelDeleterep: 'enter_screen.delete-entry.dialog-label-deleterep',
      dialogLabelTitle: 'enter_screen.delete-entry.dialog-label-title'
    ),
    changeModeSelection: (
      title: 'enter_screen.change-mode-selection.title',
      all: 'enter_screen.change-mode-selection.all',
      thisAndAllAfter: 'enter_screen.change-mode-selection.this-and-all-after',
      onlyThisOne: 'enter_screen.change-mode-selection.only-this-one',
      thisAndAllBefore: 'enter_screen.change-mode-selection.this-and-all-before'
    ),
    expensesTextfieldTitle: 'enter_screen.expenses-textfield-title',
    incomeTextfieldTitle: 'enter_screen.income-textfield-title',
    title: (add: 'enter_screen.title.add', edit: 'enter_screen.title.edit'),
    transactionTextfieldTitle: 'enter_screen.transaction-textfield-title'
  ),
  homeScreen: (
    buttonShowAll: 'home_screen.button-show-all',
    buttonShowMore: 'home_screen.button-show-more',
    freeText: 'home_screen.free-text',
    labelActiveSerialcontracts: 'home_screen.label-active-serialcontracts',
    labelRecentTransactions: 'home_screen.label-recent-transactions'
  ),
  homeScreenCard: (
    homeScreenCardToast: 'home_screen_card.home-screen-card-toast',
    labelCurrentBalance: 'home_screen_card.label-current-balance',
    labelExpenses: 'home_screen_card.label-expenses',
    labelIncome: 'home_screen_card.label-income',
    labelTotalBalance: 'home_screen_card.label-total-balance',
    labelTotalBalanceSub: 'home_screen_card.label-total-balance-sub',
    labelMonthlyPlanner: 'home_screen_card.label-monthly-planner',
    labelMtdBalance: 'home_screen_card.label-mtd-balance',
    labelContracts: 'home_screen_card.label-contracts',
    labelEomProjectedBalance: 'home_screen_card.label-eom-projected-balance',
    labelAccountPositionMonth: 'home_screen_card.label-account-position-month'
  ),
  listview: (
    dismissible: (labelDelete: 'listview.dismissible.label-delete'),
    labelDays: 'listview.label-days',
    labelErrorTranslation: 'listview.label-error-translation',
    labelEvery: 'listview.label-every',
    labelFuture: 'listview.label-future',
    labelLastweek: 'listview.label-lastweek',
    labelMonths: 'listview.label-months',
    labelNoEntries: 'listview.label-no-entries',
    labelThismonth: 'listview.label-thismonth',
    labelToday: 'listview.label-today',
    labelWeeks: 'listview.label-weeks',
    labelYears: 'listview.label-years',
    labelYesterday: 'listview.label-yesterday'
  ),
  lockScreen: (
    change: (
      labelButton: 'lock_screen.change.label-button',
      labelTitle: 'lock_screen.change.label-title'
    ),
    errors: (lastMailMissing: 'lock_screen.errors.last-mail-missing'),
    initialize: (
      labelButton: 'lock_screen.initialize.label-button',
      labelTitle: 'lock_screen.initialize.label-title'
    ),
    recall: (
      labelButton: 'lock_screen.recall.label-button',
      labelTitle: 'lock_screen.recall.label-title'
    ),
    toastPinChanged: 'lock_screen.toast-pin-changed',
    toastPinDeactivated: 'lock_screen.toast-pin-deactivated',
    toastPinSet: 'lock_screen.toast-pin-set',
    toastWrongCode: 'lock_screen.toast-wrong-code'
  ),
  logoutForm: (labelCurrentEmail: 'logout_form.label-current-email'),
  main: (
    labelError: 'main.label-error',
    labelLoading: 'main.label-loading',
    labelWip: 'main.label-wip'
  ),
  onboardingScreen: (
    appleButton: 'onboarding_screen.apple-button',
    card1Description: 'onboarding_screen.card1-description',
    card1Title: 'onboarding_screen.card1-title',
    card2Description: 'onboarding_screen.card2-description',
    card2Title: 'onboarding_screen.card2-title',
    card3Description: 'onboarding_screen.card3-description',
    card3Title: 'onboarding_screen.card3-title',
    card4Description: 'onboarding_screen.card4-description',
    card4Title: 'onboarding_screen.card4-title',
    ctaLogin: 'onboarding_screen.cta-login',
    ctaRegister: 'onboarding_screen.cta-register',
    googleButton: 'onboarding_screen.google-button',
    loginButton: 'onboarding_screen.login-button',
    loginEmailErrorlabel: 'onboarding_screen.login-email-errorlabel',
    loginEmailHintlabel: 'onboarding_screen.login-email-hintlabel',
    loginLipForgotPasswordButton:
        'onboarding_screen.login-lip-forgot-password-button',
    loginLipLoginButton: 'onboarding_screen.login-lip-login-button',
    loginLipTitle: 'onboarding_screen.login-lip-title',
    loginPasswordErrorlabel: 'onboarding_screen.login-password-errorlabel',
    loginPasswordHintlabel: 'onboarding_screen.login-password-hintlabel',
    registerButton: 'onboarding_screen.register-button',
    registerEmailErrorlabel: 'onboarding_screen.register-email-errorlabel',
    registerEmailHintlabel: 'onboarding_screen.register-email-hintlabel',
    registerLipForgotPasswordButton:
        'onboarding_screen.register-lip-forgot-password-button',
    registerLipSignupButton: 'onboarding_screen.register-lip-signup-button',
    registerLipTitle: 'onboarding_screen.register-lip-title',
    registerPasswordErrorlabel:
        'onboarding_screen.register-password-errorlabel',
    registerPasswordHintlabel: 'onboarding_screen.register-password-hintlabel',
    registerPrivacy: (
      labelLeading: 'onboarding_screen.register-privacy.label-leading',
      labelLink: 'onboarding_screen.register-privacy.label-link',
      labelTrailing: 'onboarding_screen.register-privacy.label-trailing'
    ),
    svgCreditLabel: 'onboarding_screen.svg-credit-label'
  ),
  settingsScreen: (
    languageSettings: (
      labelDe: 'settings_screen.language-settings.label-de',
      labelEn: 'settings_screen.language-settings.label-en',
      labelNl: 'settings_screen.language-settings.label-nl',
      labelSystemlang: 'settings_screen.language-settings.label-systemlang',
      labelTitle: 'settings_screen.language-settings.label-title',
      labelTooltip: 'settings_screen.language-settings.label-tooltip'
    ),
    pinLock: (
      labelChangePin: 'settings_screen.pin-lock.label-change-pin',
      labelTitle: 'settings_screen.pin-lock.label-title',
      labelTooltip: 'settings_screen.pin-lock.label-tooltip',
      switchLabel: 'settings_screen.pin-lock.switch-label'
    ),
    specialSettings: (
      labelSchwabenmodus:
          'settings_screen.special-settings.label-schwabenmodus',
      labelTitle: 'settings_screen.special-settings.label-title'
    ),
    standardAccount: (
      labelTitle: 'settings_screen.standard-account.label-title',
      labelTooltip: 'settings_screen.standard-account.label-tooltip'
    ),
    standardAccountSelector: (
      cash: 'settings_screen.standard-account-selector.cash',
      creditCard: 'settings_screen.standard-account-selector.credit-card',
      debitCard: 'settings_screen.standard-account-selector.debit-card',
      deposit: 'settings_screen.standard-account-selector.deposit',
      labelTitle: 'settings_screen.standard-account-selector.label-title',
      modalLabelTitle:
          'settings_screen.standard-account-selector.modal-label-title'
    ),
    standardCategory: (
      labelTitle: 'settings_screen.standard-category.label-title',
      labelTooltip: 'settings_screen.standard-category.label-tooltip'
    ),
    standardCurrency: (
      labelTitle: 'settings_screen.standard-currency.label-title',
      labelTooltip: 'settings_screen.standard-currency.label-tooltip'
    ),
    standardExpenseSelector: (
      car: 'settings_screen.standard-expense-selector.car',
      food: 'settings_screen.standard-expense-selector.food',
      freetime: 'settings_screen.standard-expense-selector.freetime',
      house: 'settings_screen.standard-expense-selector.house',
      labelTitle: 'settings_screen.standard-expense-selector.label-title',
      lifestyle: 'settings_screen.standard-expense-selector.lifestyle',
      misc: 'settings_screen.standard-expense-selector.misc'
    ),
    standardIncomeSelector: (
      allowance: 'settings_screen.standard-income-selector.allowance',
      childsupport: 'settings_screen.standard-income-selector.childsupport',
      interest: 'settings_screen.standard-income-selector.interest',
      investments: 'settings_screen.standard-income-selector.investments',
      labelTitle: 'settings_screen.standard-income-selector.label-title',
      misc: 'settings_screen.standard-income-selector.misc',
      salary: 'settings_screen.standard-income-selector.salary',
      sidejob: 'settings_screen.standard-income-selector.sidejob'
    ),
    standardsSelectorNone: 'settings_screen.standards-selector-none',
    systemSettings: (
      buttonDeleteUser: 'settings_screen.system-settings.button-delete-user',
      buttonForgotPassword:
          'settings_screen.system-settings.button-forgot-password',
      buttonForgotPasswordTooltip:
          'settings_screen.system-settings.button-forgot-password-tooltip',
      buttonSignout: 'settings_screen.system-settings.button-signout',
      labelTitle: 'settings_screen.system-settings.label-title'
    )
  )
);
