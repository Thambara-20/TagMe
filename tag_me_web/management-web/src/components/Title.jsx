import { Typography } from '@mui/material'
import React from 'react'

const Title = ({ text, textAlign }) => {
  return (
    <Typography 
    variant='h4'
    padding={2}
    sx={{ 
      fontWeight: '600',
      textAlign: textAlign,
   }}
    >
      {text}
    </Typography>
  )
}

export default Title