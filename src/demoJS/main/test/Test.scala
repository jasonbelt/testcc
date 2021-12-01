// #Sireum
package test

import org.sireum._

object Test extends App {

  def main(args: ISZ[String]): Z = {

    CCTest.init()

    for(i <- 1 to 10) {
      CCTest.addMessage(s"${i}")
    }

    CCTest.waitx()

    return 0
  }
}
