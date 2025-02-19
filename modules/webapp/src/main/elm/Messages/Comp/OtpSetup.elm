{-
   Copyright 2020 Eike K. & Contributors

   SPDX-License-Identifier: AGPL-3.0-or-later
-}


module Messages.Comp.OtpSetup exposing
    ( Texts
    , de
    , gb
    )

import Data.TimeZone exposing (TimeZone)
import Http
import Messages.Comp.HttpError
import Messages.DateFormat
import Messages.UiLanguage


type alias Texts =
    { httpError : Http.Error -> String
    , formatDateShort : Int -> String
    , errorTitle : String
    , stateErrorInfoText : String
    , errorGeneratingQR : String
    , initErrorInfo : String
    , confirmErrorInfo : String
    , disableErrorInfo : String
    , twoFaActiveSince : String
    , revert2FAText : String
    , disableButton : String
    , disableConfirmBoxInfo : String
    , setupTwoFactorAuth : String
    , setupTwoFactorAuthInfo : String
    , activateButton : String
    , setupConfirmLabel : String
    , scanQRCode : String
    , codeInvalid : String
    , ifNotQRCode : String
    , reloadToTryAgain : String
    , twoFactorNowActive : String
    , revertInfo : String
    }


gb : TimeZone -> Texts
gb tz =
    { httpError = Messages.Comp.HttpError.gb
    , formatDateShort = Messages.DateFormat.formatDateShort Messages.UiLanguage.English tz
    , errorTitle = "Error"
    , stateErrorInfoText = "There was a problem determining the current state of your two factor authentication scheme:"
    , errorGeneratingQR = "Error generating QR Code"
    , initErrorInfo = "There was an error when initializing two-factor authentication."
    , confirmErrorInfo = "There was an error when confirming the setup!"
    , disableErrorInfo = "There was an error when disabling 2FA!"
    , twoFaActiveSince = "Two Factor Authentication is active since "
    , revert2FAText = "If you really want to revert back to password-only authentication, you can do this here. You can run the setup any time to enable the second factor again."
    , disableButton = "Disable 2FA"
    , disableConfirmBoxInfo = "Enter a TOTP code and click the button to disable 2FA."
    , setupTwoFactorAuth = "Setup Two Factor Authentication"
    , setupTwoFactorAuthInfo = "You can setup a second factor for authentication using a one-time password. When clicking the button a secret is generated that you can load into an app on your mobile device. The app then provides a 6 digit code that you need to pass in the field in order to confirm and finalize the setup."
    , activateButton = "Activate two-factor authentication"
    , setupConfirmLabel = "Confirm"
    , scanQRCode = "Scan this QR code with your device and enter the 6 digit code:"
    , codeInvalid = "The code was invalid!"
    , ifNotQRCode = "If you cannot use the qr code, enter this secret:"
    , reloadToTryAgain = "If you want to try again, reload the page."
    , twoFactorNowActive = "Two Factor Authentication is now active!"
    , revertInfo = "You can revert back to password-only auth any time (reload this page)."
    }


de : TimeZone -> Texts
de tz =
    { httpError = Messages.Comp.HttpError.de
    , formatDateShort = Messages.DateFormat.formatDateShort Messages.UiLanguage.German tz
    , errorTitle = "Fehler"
    , stateErrorInfoText = "Es gab ein Problem, den Status der Zwei-Faktor-Authentifizierung zu ermittlen:"
    , errorGeneratingQR = "Fehler beim Generieren des QR-Code"
    , initErrorInfo = "Es gab ein Problem beim Initialisieren der Zwei-Faktor-Authentifizierung."
    , confirmErrorInfo = "Es gab ein Problem bei der Verifizierung!"
    , disableErrorInfo = "Es gab ein Problem die Zwei-Faktor-Authentifizierung zu entfernen."
    , twoFaActiveSince = "Die Zwei-Faktor-Authentifizierung ist aktiv seit "
    , revert2FAText = "Die Zwei-Faktor-Authentifizierung kann hier wieder deaktiviert werden. Danach kann die Einrichtung wieder von neuem gestartet werden, um 2FA wieder zu aktivieren."
    , disableButton = "Deaktiviere 2FA"
    , disableConfirmBoxInfo = "Tippe `OK` in das Feld und klicke, um die Zwei-Faktor-Authentifizierung zu deaktivieren."
    , setupTwoFactorAuth = "Zwei-Faktor-Authentifizierung einrichten"
    , setupTwoFactorAuthInfo = "Ein zweiter Faktor zur Authentifizierung mittels eines Einmalkennworts kann eingerichtet werden. Beim Klicken des Button wird ein Schlüssel generiert, der an eine Authentifizierungs-App eines mobilen Gerätes übetragen werden kann. Danach präsentiert die App ein 6-stelliges Kennwort, welches zur Bestätigung und zum Abschluss angegeben werden muss."
    , activateButton = "Zwei-Faktor-Authentifizierung aktivieren"
    , setupConfirmLabel = "Bestätigung"
    , scanQRCode = "Scanne den QR Code mit der Authentifizierungs-App und gebe den 6-stelligen Code ein:"
    , codeInvalid = "Der Code war ungültig!"
    , ifNotQRCode = "Wenn der QR-Code nicht möglich ist, kann der Schlüssel manuell eingegeben werden:"
    , reloadToTryAgain = "Um es noch einmal zu versuchen, bitte die Seite neu laden."
    , twoFactorNowActive = "Die Zwei-Faktor-Authentifizierung ist nun aktiv!"
    , revertInfo = "Es kann jederzeit zur normalen Passwort-Authentifizierung zurück gegangen werden (dazu Seite neu laden)."
    }
