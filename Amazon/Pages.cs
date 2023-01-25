using OpenQA.Selenium;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Amazon
{
    public class Pages
    {
        private Results results;
        public Results Results
        {
            get
            {
                if (this.results == null)
                    this.results = new Results(this.Driver);
                return this.results;
            }
  
        }
        private Home home;

        public Home Home
        {
            get
            {
                if (this.home == null)
                    this.home = new Home(this.Driver);
                return this.home;
            }

        }

        private IWebDriver Driver;
        public Pages(IWebDriver driver)
        {
            this.Driver = driver;
           

        }
    }
}
