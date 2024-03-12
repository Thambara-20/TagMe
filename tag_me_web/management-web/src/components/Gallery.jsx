import React from "react";
// mui
import { Typography, Box, Stack, Button } from "@mui/material";
// carousel
import "react-responsive-carousel/lib/styles/carousel.min.css";

import Title from "./Title";
import ArrowOutwardIcon from "@mui/icons-material/ArrowOutward";
import { Link } from "react-router-dom";

const Gallery = () => {
  return (
    <Stack
      direction="column"
      justifyContent="center"
      alignItems="center"
      sx={{
        py: 8,
        px: 2,
        display: { xs: "flex" },
      }}
    >
      <Box
        component="section"
        alignItems={"center"}
        justifyContent={"center"}
        sx={{
          paddingBottom: 3,
        }}
      >
        <Title text={"More Details"} textAlign={"center"} />

        <a href="https://tag-me.web.app">
          <Button
            variant="contained"
            type="submit"
            size="medium"
            sx={{
              fontSize: "1.25rem",
              textTransform: "capitalize",
              py: 2,
              px: 4,
              mt: 3,
              mb: 2,
              borderRadius: 10,
              backgroundColor: "#14192d",
              "&:hover": {
                backgroundColor: "#1e2a5a",
              },
            }}
          >
            get in touch
            <ArrowOutwardIcon
              sx={{
                ml: 1,
              }}
            />
          </Button>
        </a>
      </Box>
    </Stack>
  );
};

export default Gallery;
