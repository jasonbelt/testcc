package test

import org.sireum._
import org.scalajs.dom
import org.scalajs.dom.document

case class ScalaJSInterface() extends TestI {

  override def init(): Unit = {
      document.addEventListener("DOMContentLoaded", { (e: dom.Event) =>
        setupUI()
      })
  }

    def setupUI(): Unit = {
      val button = document.createElement("button")
      button.textContent = "Click me!"
      button.addEventListener("click", { (e: dom.MouseEvent) =>
        addClickedMessage()
      })
      document.body.appendChild(button)

      appendPar(document.body, "Hello World")
    }

    def appendPar(targetNode: dom.Node, text: scala.Predef.String): Unit = {
      val parNode = document.createElement("p")
      parNode.textContent = text
      targetNode.appendChild(parNode)
    }

    def addClickedMessage(): Unit = {
      appendPar(document.body, "You clicked the button!")
    }

  override def addMessage(msg: String): Unit = {
    appendPar(document.body, msg.native)
  }

  override def waitx(): Unit = { }
}
