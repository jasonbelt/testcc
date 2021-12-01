package test

import org.sireum._
import java.awt._
import javax.swing._

case class JVMInterface() extends TestI {

  var frame: JFrame = _
  var textArea: JTextArea = _

  override def init(): Unit = {
    println("Hello there from init")
    val width = 500
    frame = new JFrame("Isolette")

    frame.setPreferredSize(new Dimension(width,300))

    val pane = frame.getContentPane
    val layout = new GridBagLayout()
    frame.getContentPane.setLayout(layout)
    val gbc = new GridBagConstraints()

    gbc.fill = GridBagConstraints.HORIZONTAL

    var y = 0

    textArea = new JTextArea()
    pane.add(textArea)

    frame.pack()
    frame.setResizable(false)
    frame.setLocationRelativeTo(null)
    frame.setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE)
    frame.setVisible(true)

  }

  override def addMessage(msg: String): Unit = {
    textArea.setText(textArea.getText + "\n" + msg)
  }

  override def waitx(): Unit = {
    while(true) {}
  }
}
