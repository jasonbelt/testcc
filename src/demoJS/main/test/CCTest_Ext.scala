package test

import org.sireum._
import org.sireum.$internal.{###, Macro}

object CCTest_Ext {

  //###(scala.util.Try(Class.forName("scala.scalajs.js.Any", false, getClass.getClassLoader)).isSuccess) {
  //###(Macro.isJs) { // "object isJs is not a member of package Macro"
  ###({
    val r = scala.util.Try(Class.forName("scala.scalajs.js.Any", false, getClass.getClassLoader)).isSuccess
    println(s"Testing for scalajs = ${r}")

    System.getenv("TARGETING_JS") != null
  }) {
    val targetingJS = T
  }

  ###(System.getenv("TARGETING_JS") == null) {
    val targetingJS = F
  }

  def dummy(): Unit = {
    println(s"Hello from CCTest: targetingJS = ${targetingJS}")
  }
}
