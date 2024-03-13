import React from "react";
import { Grid } from "@mui/material";
import Table from "./DataGrid";
import Selecter from "./Dropdowns";

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
       <Selecter text={"District"}/>
       <Selecter text={"club"}/>
       <Selecter text= {"year"}/>
       <Selecter text= {"month"}/>
       <Table/>
    </Grid>
  );
};

export default Content;
