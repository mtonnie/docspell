/*
 * Copyright 2020 Eike K. & Contributors
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

package docspell.config

import java.nio.file.{Path => JPath}

import scala.reflect.ClassTag

import fs2.io.file.Path

import docspell.common._
import docspell.logging.{Level, LogConfig}

import com.github.eikek.calev.CalEvent
import pureconfig.ConfigReader
import pureconfig.error.{CannotConvert, FailureReason}
import scodec.bits.ByteVector

object Implicits {
  implicit val accountIdReader: ConfigReader[AccountId] =
    ConfigReader[String].emap(reason(AccountId.parse))

  implicit val pathReader: ConfigReader[Path] =
    ConfigReader[JPath].map(Path.fromNioPath)

  implicit val lenientUriReader: ConfigReader[LenientUri] =
    ConfigReader[String].emap(reason(LenientUri.parse))

  implicit val durationReader: ConfigReader[Duration] =
    ConfigReader[scala.concurrent.duration.Duration].map(sd => Duration(sd))

  implicit val passwordReader: ConfigReader[Password] =
    ConfigReader[String].map(Password(_))

  implicit val mimeTypeReader: ConfigReader[MimeType] =
    ConfigReader[String].emap(reason(MimeType.parse))

  implicit val identReader: ConfigReader[Ident] =
    ConfigReader[String].emap(reason(Ident.fromString))

  implicit val byteVectorReader: ConfigReader[ByteVector] =
    ConfigReader[String].emap(reason { str =>
      if (str.startsWith("hex:"))
        ByteVector.fromHex(str.drop(4)).toRight("Invalid hex value.")
      else if (str.startsWith("b64:"))
        ByteVector.fromBase64(str.drop(4)).toRight("Invalid Base64 string.")
      else
        ByteVector
          .encodeUtf8(str)
          .left
          .map(ex => s"Invalid utf8 string: ${ex.getMessage}")
    })

  implicit val caleventReader: ConfigReader[CalEvent] =
    ConfigReader[String].emap(reason(CalEvent.parse))

  implicit val priorityReader: ConfigReader[Priority] =
    ConfigReader[String].emap(reason(Priority.fromString))

  implicit val nlpModeReader: ConfigReader[NlpMode] =
    ConfigReader[String].emap(reason(NlpMode.fromString))

  implicit val logFormatReader: ConfigReader[LogConfig.Format] =
    ConfigReader[String].emap(reason(LogConfig.Format.fromString))

  implicit val logLevelReader: ConfigReader[Level] =
    ConfigReader[String].emap(reason(Level.fromString))

  def reason[A: ClassTag](
      f: String => Either[String, A]
  ): String => Either[FailureReason, A] =
    in =>
      f(in).left.map(str =>
        CannotConvert(in, implicitly[ClassTag[A]].runtimeClass.toString, str)
      )
}
