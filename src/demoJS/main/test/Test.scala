
package test

import org.sireum._

//object Test extends App {
object Test extends scala.App {

  App.args = ISZ(args.toIndexedSeq.map(String(_)): _*)
  main(App.args)

  def main(args: ISZ[String]): Z = {
    println("Hello")

    CCTest.dummy()

    return 0
  }
}
