return {
   {
      desc = "quick printf",
      prefix = "pf",
      body = "fmt.Printf($1)",
   },
   {
      desc = "quick println",
      prefix = "pl",
      body = "fmt.Println($1)",
   },
   {
      desc = "quick sprintf",
      prefix = "spf",
      body = "fmt.Sprintf($1)",
   },
   {
      desc = "iferr",
      prefix = "iferr",
      body = {
         "if err != nil {",
         "\t${1:return err}",
         "}",
      },
   },
}
