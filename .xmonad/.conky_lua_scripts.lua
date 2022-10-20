function conky_pad( format, number )
  return string.format( format, conky_parse( number ) )
end
