package test

import org.sireum._
import org.sireum.$internal.###


trait TestI {
  def init(): Unit

  def addMessage(msg: String): Unit

  def waitx(): Unit
}

object CCTest_Ext {

  var interface: TestI = _

  ###("true" == System.getenv("PROYEK_JS")) {
    interface = ScalaJSInterface()
  }

  ###("true" != System.getenv("PROYEK_JS")) {
    interface = JVMInterface()
  }

  def init(): Unit = {
    interface.init()
  }

  def addMessage(msg: String): Unit = {
    interface.addMessage(msg)
  }

  def waitx(): Unit = {
    interface.waitx()
  }
}
