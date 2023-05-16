namespace PiggyBankWeb
{
    public class ConfigurationController : Controller
    {
        private readonly PiggyBankContext _context;

        public ConfigurationController(PiggyBankContext context)
        {
            _context = context;
        }

        // GET: Configuration
        public async Task<IActionResult> Index()
        {
            return View(await _context.Configurations.ToListAsync());
        }

        // GET: Configuration/Details/5
        public async Task<IActionResult> Details(Guid? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var configuration = await _context.Configurations
                .FirstOrDefaultAsync(m => m.Id == id);
            if (configuration == null)
            {
                return NotFound();
            }

            return View(configuration);
        }

        // GET: Configuration/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Configuration/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Key,Value,Id")] Configuration configuration)
        {
            if (ModelState.IsValid)
            {
                configuration.Id = Guid.NewGuid();
                _context.Add(configuration);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(configuration);
        }

        // GET: Configuration/Edit/5
        public async Task<IActionResult> Edit(Guid? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var configuration = await _context.Configurations.FindAsync(id);
            if (configuration == null)
            {
                return NotFound();
            }
            return View(configuration);
        }

        // POST: Configuration/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(Guid id, [Bind("Key,Value,Id")] Configuration configuration)
        {
            if (id != configuration.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(configuration);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ConfigurationExists(configuration.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(configuration);
        }

        // GET: Configuration/Delete/5
        public async Task<IActionResult> Delete(Guid? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var configuration = await _context.Configurations
                .FirstOrDefaultAsync(m => m.Id == id);
            if (configuration == null)
            {
                return NotFound();
            }

            return View(configuration);
        }

        // POST: Configuration/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(Guid id)
        {
            var configuration = await _context.Configurations.FindAsync(id);
            if (configuration != null)
            {
                _context.Configurations.Remove(configuration);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ConfigurationExists(Guid id)
        {
            return _context.Configurations.Any(e => e.Id == id);
        }
    }
}
