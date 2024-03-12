import React from "react";
import { Grid } from "@mui/material";
import Table from "./DataGrid";

const Content = () => {
  return (
    <Grid
      container
      spacing={0}
      sx={{
        display: "flex",
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        py: 10,
        px: 2,
      }}
    >
       <Table/>
    </Grid>
  );
};

export default Content;
