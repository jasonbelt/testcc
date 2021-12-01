package test

import org.sireum._
import org.sireum.$internal.###

object CCTest_Ext {

  ###("true" == System.getenv("PROYEK_JS")) {
    val targetingJS = T
  }

  ###("true" != System.getenv("PROYEK_JS")) {
    val targetingJS = F
  }

  def dummy(): Unit = {
    println(s"Hello from CCTest: targetingJS = ${targetingJS}")
  }
}
