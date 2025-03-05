require('boole').setup({
  mappings = {
    increment = '<C-a>',
    decrement = '<C-x>'
  },
  -- User defined loops
  additions = {
    -- {'tic', 'tac', 'toe'}
    {'top', 'right', 'bottom', 'left'},
    {'mainAxisAlignment', 'crossAxisAlignment'},
    {'MainAxisAlignment', 'CrossAxisAlignment'},
  },
  allow_caps_additions = {
    {'enable', 'disable'},
    {'true', 'false'},
    {'min', 'max'},
    {'minimum', 'maximum'},
    {'vertical', 'horizontal'},
    -- enable → disable
    -- Enable → Disable
    -- ENABLE → DISABLE
  }
})
