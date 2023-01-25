using OpenQA.Selenium;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Amazon
{
    public class Home
    {
        private SearchBar searchBar;
        public IWebDriver driver;
        public SearchBar SearchBar
        {
            get
            {
                if (this.searchBar == null)
                    this.searchBar = new SearchBar(this.driver);
                return this.searchBar;
            }

        }
        public Home(IWebDriver driver)
        {
            this.driver = driver;
            
        }
    }
}
