using OpenQA.Selenium;

namespace Amazon
{
    public class Tests
    {
        BrowsherFactory browsher;
        IWebDriver driver;
        List<Item>l=new List<Item>();
        public enum forDictionary
        {
            price_low_then,
            price_higer_or_equal,
            free_shipping
        }

        [SetUp]
        public void Setup()
        {
                browsher = new BrowsherFactory();
                browsher.InitBrowser("Chrome");
                driver = browsher.retuenDriver("Chrome");



        }

        [Test]
        public void Test1()
        {

            Amazon tester = new Amazon(driver, "https://www.amazon.com/?language=en_US&currency=USD");
            tester.Pages.Home.SearchBar.Text = "mouse";
            tester.Pages.Home.SearchBar.click();
            l=tester.Pages.Results.GetResultBy(new Dictionary<string, string>(){ { "price_low_then","20"},{ "free_shipping","True" } });

            foreach (var i in l)
            {
                Console.WriteLine(i);
            }
            Assert.Pass();
        }
    }
}