#r "System.ServiceProcess"
#load "EnvironmentHelper.fsx"

Console.WriteLine(EnvironmentHelper.isMono)


module env = EnvironmentHelper 
module ProcessHelper =

  open System
  open System.ComponentModel
  open System.Diagnostics
  open System.IO
  open System.Threading
  open System.Collections.Generic
  open System.ServiceProcess
  open System.Configuration

  let pwd () = Directory.GetCurrentDirectory()
  let ttc = env.isMono
